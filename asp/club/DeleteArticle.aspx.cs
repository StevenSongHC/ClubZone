using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Data.SqlClient;
using System.Data;

public partial class asp_club_DeleteArticle : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["id"].ToString() == null || Request.QueryString["clubid"].ToString() == null || Request.QueryString["id"].ToString() == "" || Request.QueryString["id"].ToString() == "")
        {
            Response.Redirect("/asp/error/IllegalParam.aspx");
        }
        int ArticleId = Convert.ToInt32(Request.QueryString["id"].ToString());
        int ClubId = Convert.ToInt32(Request.QueryString["clubid"].ToString());
        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["CZConnectionString"].ConnectionString;
        SqlConnection conn = new SqlConnection(connString);
        conn.Open();
        // 先检查是否为吧主
        string queryString1 = "Select * From ClubMember Where ClubId=(Select ClubId From Article Where Id=" + ArticleId + ") And UserId='" + Membership.GetUser().ProviderUserKey + "' And IsLeader=1";
        SqlCommand cmd = new SqlCommand(queryString1, conn);
        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
        DataSet ds = new DataSet();
        adapter.Fill(ds, "ClubLeader");
        if (ds.Tables["ClubLeader"].Rows.Count == 0)
        {
            // 非吧主
            Response.Redirect("/asp/error/AccessDenied.aspx");
        }
        else
        {
            // 删除帖子，暂不删除对应帖子下的回复反正在个人主页也检索不到！！！
            string queryString2 = "Delete From Article Where Id=" + ArticleId;
            cmd = new SqlCommand(queryString2, conn);
            cmd.ExecuteNonQuery();
            // 返回原先界面
            // 先查询执行删除后的总社团帖子列表，好返回合法的page参数
            string queryString3 = "Select * From Article Where ClubId=(Select ClubId From Article Where Id=" + ArticleId + ")";
            conn = new SqlConnection(connString);
            cmd = new SqlCommand(queryString3, conn);
            adapter = new SqlDataAdapter(cmd);
            ds = new DataSet();
            adapter.Fill(ds, "ArticleList");
            PagedDataSource pds = new PagedDataSource();
            pds.DataSource = ds.Tables["ArticleList"].DefaultView;
            pds.AllowPaging = true;
            pds.PageSize = 5;
            int PageCount = pds.PageCount;
            // 获得合法的原page参数
            int CurrentPage;
            if (Request.QueryString["page"] != null && Request.QueryString["page"] != "")
            {
                CurrentPage = Convert.ToInt32(Request.QueryString["page"]);
            }
            else
            {
                // 默认值1
                CurrentPage = 1;
            }
            // 大于取最大，不得小于1
            if (CurrentPage > PageCount)
            {
                CurrentPage = PageCount;
            }
            if (CurrentPage < 1)
            {
                CurrentPage = 1;
            }
            // 返回重定向
            Response.Redirect("/asp/club/Manage.aspx?id=" + ClubId + "&page=" + CurrentPage + "#article-list");
        }
    }
}