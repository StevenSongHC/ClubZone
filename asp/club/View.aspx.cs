using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Security;
using System.Data.SqlClient;
using System.Data;
using System.ComponentModel;

public partial class asp_club_View : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // 判断社团名是否为空，空就重定向
        if (Request.QueryString["name"] == null)
        {
            Response.Redirect("/asp/error/IllegalParam.aspx");
        }
        string ClubName = Request.QueryString["name"].ToString();
        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["CZConnectionString"].ConnectionString;
        SqlConnection conn = new SqlConnection(connString);
        conn.Open();
        string queryString1 = "Select * From (Select * From Club Where Name=N'" + ClubName + "')Info,(Select Count (UserId) As MemberCount From ClubMember Where ClubId=(Select Id From Club Where Name=N'" + ClubName + "'))Count1,(Select Count (Id) As ArticleCount From Article Where ClubId=(Select Id From Club Where Name=N'" + ClubName + "'))Count2";
        SqlCommand cmd = new SqlCommand(queryString1, conn);
        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
        DataSet ds = new DataSet();
        adapter.Fill(ds);
        // 访问社团存在或者不在黑名单
        if (ds.Tables[0].Rows.Count > 0)
        {
            TitleName.Text = ds.Tables[0].Rows[0]["Name"].ToString();
            ClubPhoto.ImageUrl = ds.Tables[0].Rows[0]["Photo"].ToString();
            ClubPhoto.AlternateText = ds.Tables[0].Rows[0]["Name"].ToString();
            ClubNameText.Text = ds.Tables[0].Rows[0]["Name"].ToString();
            ClubIntroText.Text = ds.Tables[0].Rows[0]["Intro"].ToString();
            MemberCount.Text = ds.Tables[0].Rows[0]["MemberCount"].ToString();
            ArticleCount.Text = ds.Tables[0].Rows[0]["ArticleCount"].ToString();
        }
        // 否则重定向到404
        else
        {
            Response.Redirect("/asp/error/404.aspx");
        }
        // 获取活动数据，之后再使用Ajax查看页数据
        string queryString2 = "Select * From Activity Where ClubId=(Select Id From Club Where Name=N'" + ClubName + "')";
        cmd = new SqlCommand(queryString2, conn);
        adapter = new SqlDataAdapter(cmd);
        adapter.Fill(ds, "Activities");
        // 分页，只显示3个
        PagedDataSource pds1 = new PagedDataSource();
        pds1.DataSource = ds.Tables["Activities"].DefaultView;
        // 这里用分页仅仅是为了得到总页数数
        pds1.AllowPaging = true;
        pds1.PageSize = 3;
        ActivityPageCount.Value = pds1.PageCount.ToString();
        // 仍然返回所有数据，在前台用脚本实现分页，毕竟这数量不算太大
        Repeater1.DataSource = ds.Tables["Activities"].DefaultView;
        Repeater1.DataBind();

        // 获取帖子列表，及相关数据
        string queryString3 = "Select A.Id,A.Title,A.Content,A.PublishDate,U.UserName As PublisherUserName,Count(R.Id) As ReplyCount From Article As A Left Join Reply As R On R.ArticleId=A.Id,aspnet_Users As U Where U.UserId=A.UserId And A.ClubId=(Select Id From Club Where Name=N'" + ClubName + "') Group By A.Id,A.Title,A.Content,A.PublishDate,U.UserName Order By A.PublishDate Desc";
        cmd = new SqlCommand(queryString3, conn);
        adapter = new SqlDataAdapter(cmd);
        adapter.Fill(ds, "Articles");
        // Paging，10 per page
        PagedDataSource pds2 = new PagedDataSource();
        pds2.DataSource = ds.Tables["Articles"].DefaultView;
        pds2.AllowPaging = true;
        pds2.PageSize = 10;
        int PageCount = pds2.PageCount;
        int CurrentPage;
        if (Request.QueryString["page"] != null)
        {
            CurrentPage = Convert.ToInt32(Request.QueryString["page"]);
        }
        else
        {
            CurrentPage = 1;
        }
        if (CurrentPage > PageCount)
        {
            Response.Redirect("/asp/club/View.aspx?name=" + ClubName + "&page=" + PageCount + "#article-list");
        }
        if (CurrentPage < 1)
        {
            Response.Redirect("/asp/club/View.aspx?name=" + ClubName + "&page=1#article-list");
        }
        if (CurrentPage == 1)
        {
            ArticlePreviousPage.Visible = false;
        }
        if (CurrentPage == PageCount)
        {
            ArticleNextPage.Visible = false;
        }
        ArticlePreviousPage.NavigateUrl = "/asp/club/View.aspx?name=" + ClubName + "&page=" + (CurrentPage -1) + "#article-list";
        ArticleNextPage.NavigateUrl = "/asp/club/View.aspx?name=" + ClubName + "&page=" + (CurrentPage + 1) + "#article-list";
        pds2.CurrentPageIndex = CurrentPage - 1;
        Repeater2.DataSource = pds2;
        Repeater2.DataBind();

        if (User.Identity.IsAuthenticated)
        {
            // 判断登陆用户是否为会员显示按钮
            string queryString4 = "Select * From ClubMember Where ClubId=(Select Id From Club Where Name=N'" + ClubName + "') And UserId='" + Membership.GetUser().ProviderUserKey + "'";
            cmd = new SqlCommand(queryString4, conn);
            adapter = new SqlDataAdapter(cmd);
            adapter.Fill(ds, "Member");
            if (ds.Tables["Member"].Rows.Count == 0)
            {
                // 不是会员
                JoinBtn.Visible = true;
                QuitBtn.Visible = false;
            }
            else
            {
                // 是会员
                JoinBtn.Visible = false;
                QuitBtn.Visible = true;
            }
        }
        else
        {
            JoinBtn.Visible = false;
            QuitBtn.Visible = false;
        }

        conn.Close();
    }

    [WebMethod(true)]
    public static string JoinClub(string ClubName, int IsJoin)
    {
        if (Membership.GetUser().ProviderUserKey != null)
        {
            string connString = System.Configuration.ConfigurationManager.ConnectionStrings["CZConnectionString"].ConnectionString;
            SqlConnection conn = new SqlConnection(connString);
            conn.Open();
            string queryString;
            // 退出社团
            if (IsJoin == -1)
            {
                // 注：社团管理员不能退出社团
                queryString = "Delete From ClubMember Where ClubId=(Select Id From Club Where Name=N'" + ClubName + "') And UserId='" + Membership.GetUser().ProviderUserKey + "' And IsLeader<>1";
            }
            else
            {
                queryString = "Insert Into ClubMember Values ((Select Id From Club Where Name=N'" + ClubName + "'),'" + Membership.GetUser().ProviderUserKey + "',0,'" + DateTime.Now.ToString() + "')";
            }
            SqlCommand cmd = new SqlCommand(queryString, conn);
            cmd.ExecuteNonQuery();
            return "{}";
        }
        return "{}";
    }

}