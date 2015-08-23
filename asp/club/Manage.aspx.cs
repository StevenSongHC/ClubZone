using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Web.Services;
using System.Data.SqlClient;
using System.Data;

public partial class asp_club_Manage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // id为空就重定向到错误界面
        if (Request.QueryString["id"] == null)
        {
            Response.Redirect("/asp/error/IllegalParam.aspx");
        }
        int ClubId = Convert.ToInt32(Request.QueryString["id"].ToString());
        string UserId = Membership.GetUser().ProviderUserKey.ToString();

        // 检索该社团是否“存在”，及是否为“吧主”，之后返回对应错误信息或正确的数据
        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["CZConnectionString"].ConnectionString;
        SqlConnection conn = new SqlConnection(connString);
        conn.Open();
        string queryString1 = "Select C.* From Club As C,ClubMember As CM Where C.Id=CM.ClubId And CM.ClubId=" + ClubId + " And CM.UserId='" + UserId +  "' And CM.IsLeader=1 And C.IsAllowed=1";
        SqlCommand cmd = new SqlCommand(queryString1, conn);
        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
        DataSet ds = new DataSet();
        adapter.Fill(ds, "Club");
        // 记录存在，则验证通过，返回请求的数据
        if (ds.Tables["Club"].Rows.Count > 0)
        {
            TitleName.Text = ds.Tables["Club"].Rows[0]["Name"].ToString();
            ClubPhoto.ImageUrl = ds.Tables["Club"].Rows[0]["Photo"].ToString();
            ClubPhoto.AlternateText = ds.Tables["Club"].Rows[0]["Name"].ToString();
            ClubUrl.Text = ds.Tables["Club"].Rows[0]["Name"].ToString();
            ClubUrl.NavigateUrl = "/asp/club/View.aspx?name=" + ds.Tables[0].Rows[0]["Name"].ToString();
            ClubUrl.Target = "_blank";
            ClubIntroText.Text = ds.Tables["Club"].Rows[0]["Intro"].ToString();
            // 显示活动
            string queryString2 = "Select * From Activity Where ClubId=" + ClubId + " Order By PublishDate Desc";
            cmd = new SqlCommand(queryString2, conn);
            adapter = new SqlDataAdapter(cmd);
            adapter.Fill(ds, "Activities");
            Repeater1.DataSource = ds.Tables["Activities"].DefaultView;
            Repeater1.DataBind();
        }
        // 不存在，重定向错误界面
        else
        {
            Response.Redirect("/asp/error/AccessDenied.aspx");
        }

        // 获取帖子列表
        string queryString3 = "Select A.Id,A.Title,A.Content,A.PublishDate,U.UserName As PublisherUserName,Count(R.Id) As ReplyCount From Article As A Left Join Reply As R On R.ArticleId=A.Id,aspnet_Users As U Where U.UserId=A.UserId And A.ClubId=" + ClubId + " Group By A.Id,A.Title,A.Content,A.PublishDate,U.UserName Order By A.PublishDate Desc";
        cmd = new SqlCommand(queryString3, conn);
        adapter = new SqlDataAdapter(cmd);
        adapter.Fill(ds, "Articles");
        PagedDataSource pds = new PagedDataSource();
        pds.DataSource = ds.Tables["Articles"].DefaultView;
        pds.AllowPaging = true;
        pds.PageSize = 5;
        int PageCount = pds.PageCount;
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
            Response.Redirect("/asp/club/Manage.aspx?id=" + ClubId + "&page=" + PageCount + "#article-list");
        }
        if (CurrentPage < 1)
        {
            Response.Redirect("/asp/club/Manage.aspx?id=" + ClubId + "&page=1" + "#article-list");
        }
        if (CurrentPage == 1)
        {
            PreviousPage.Visible = false;
        }
        if (CurrentPage == PageCount)
        {
            NextPage.Visible = false;
        }
        PreviousPage.NavigateUrl = "/asp/club/Manage.aspx?id=" + ClubId + "&page=" + (CurrentPage - 1) + "#article-list";
        NextPage.NavigateUrl = "/asp/club/Manage.aspx?id=" + ClubId + "&page=" + (CurrentPage + 1) + "#article-list";
        pds.CurrentPageIndex = CurrentPage - 1;


        Repeater2.DataSource = pds;
        Repeater2.DataBind();

    }

    [WebMethod(true)]
    public static string PublishActivity(int ClubId, string ActivityContent)
    {
        // 将新增活动存入数据库，并从数据库返回信息及数据
        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["CZConnectionString"].ConnectionString;
        SqlConnection conn = new SqlConnection(connString);
        conn.Open();
        // 存储
        string PublishDate = DateTime.Now.ToString();
        string queryString1 = "Insert Into Activity Values (" + ClubId + ",N'" + ActivityContent + "','" + PublishDate + "')";
        SqlCommand cmd = new SqlCommand(queryString1, conn);
        cmd.ExecuteNonQuery();
        // 查询最后插入的数据，就是新的数据
        string queryString2 = "Select Top 1 * From Activity Where ClubId=" + ClubId + " Order By PublishDate Desc";
        cmd = new SqlCommand(queryString2, conn);
        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
        DataSet ds = new DataSet();
        adapter.Fill(ds);
        int Id = Convert.ToInt32(ds.Tables[0].Rows[0]["Id"].ToString());
        string Content = ds.Tables[0].Rows[0]["Content"].ToString();
        string Date = ds.Tables[0].Rows[0]["PublishDate"].ToString();

        conn.Close();

        // 通过判断前后时间知是否查入成功
        if (PublishDate == Date)
        {
            return "{status:1,id:" + Id + ",content:'" + Content + "',date:'" + Date + "'}";
        }
        else
        {
            return "{status:-1}";
        }
    }

    [WebMethod(true)]
    public static string EditActivity(int Id, string Content)
    {
        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["CZConnectionString"].ConnectionString;
        SqlConnection conn = new SqlConnection(connString);
        conn.Open();
        string queryString = "Update Activity Set Content=N'" + Content + "' Where Id=" + Id;
        SqlCommand cmd = new SqlCommand(queryString, conn);
        cmd.ExecuteNonQuery();
        conn.Close();
        return "{status:1}";
    }

    [WebMethod(true)]
    public static string DeleteActivity(int Id)
    {
        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["CZConnectionString"].ConnectionString;
        SqlConnection conn = new SqlConnection(connString);
        conn.Open();
        string queryString = "Delete From Activity Where Id=" + Id;
        SqlCommand cmd = new SqlCommand(queryString, conn);
        cmd.ExecuteNonQuery();
        conn.Close();
        return "{status:1}";
    }

}