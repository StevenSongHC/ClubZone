using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Data.SqlClient;
using System.Data;

public partial class asp_club_ReplyArticle : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        if (Request.QueryString["articleid"].ToString() == null || Request.QueryString["input-reply"].ToString() == null || Request.QueryString["articleid"].ToString() == "" || Request.QueryString["input-reply"].ToString() == "")
        {
            Response.Redirect("/asp/error/IllegalParam.aspx");
        }
        int ArticleId = Convert.ToInt32(Request.QueryString["articleid"].ToString());
        string Content = Request.QueryString["input-reply"].ToString();

        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["CZConnectionString"].ConnectionString;
        SqlConnection conn = new SqlConnection(connString);
        conn.Open();
        string queryString = "Insert Into Reply Values(" + ArticleId + ",'" + Membership.GetUser().ProviderUserKey + "',N'" + Content + "','" + DateTime.Now.ToString() + "')";
        SqlCommand cmd = new SqlCommand(queryString, conn);
        cmd.ExecuteNonQuery();
        // 回复完后回到帖子页
        Response.Write("<script>window.location.href='/asp/club/Article.aspx?id=" + ArticleId + "';</script>");

        conn.Close();
    }
}