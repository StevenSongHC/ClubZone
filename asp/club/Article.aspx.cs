using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class asp_club_Article : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["id"] == null)
        {
            Response.Redirect("/asp/error/IllegalParam.aspx");
        }
        int ArticleId = Convert.ToInt32(Request.QueryString["id"].ToString());

        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["CZConnectionString"].ConnectionString;
        SqlConnection conn = new SqlConnection(connString);
        conn.Open();
        // 检索帖子内容
        string queryString1 = "Select A.*,U.UserName,C.Name As ClubName From Article As A,aspnet_Users As U,Club As C Where U.UserId=A.UserId And C.Id=A.ClubId And A.Id=" + ArticleId;
        SqlCommand cmd = new SqlCommand(queryString1, conn);
        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
        DataSet ds = new DataSet();
        adapter.Fill(ds, "Article");

        // display
        if (ds.Tables["Article"].Rows.Count > 0)
        {
            ClubUrl.NavigateUrl = "/asp/club/View.aspx?name=" + ds.Tables["Article"].Rows[0]["ClubName"].ToString();
            ClubUrl.Text = ds.Tables["Article"].Rows[0]["ClubName"].ToString();
            ArticleTitleText1.Text = ds.Tables["Article"].Rows[0]["Title"].ToString();
            ArticleTitleText2.Text = ds.Tables["Article"].Rows[0]["Title"].ToString();
            ArticleTitleText3.Text = ds.Tables["Article"].Rows[0]["Title"].ToString();
            ClubNameText.Text = ds.Tables["Article"].Rows[0]["ClubName"].ToString();
            ArticleContentText.Text = ds.Tables["Article"].Rows[0]["Content"].ToString();
            PublisherNameText.Text = ds.Tables["Article"].Rows[0]["UserName"].ToString();
            PublishDateText.Text = ds.Tables["Article"].Rows[0]["PublishDate"].ToString();

            // 检索回复列表
            string queryString2 = "Select Reply.*,aspnet_Users.UserName As ReplyUserName From Reply,aspnet_Users Where aspnet_Users.UserId=Reply.UserId And Reply.ArticleId=" + ArticleId;
            cmd = new SqlCommand(queryString2, conn);
            adapter = new SqlDataAdapter(cmd);
            ds = new DataSet();
            adapter.Fill(ds, "Reply");
            Repeater1.DataSource = ds.Tables["Reply"].DefaultView;
            Repeater1.DataBind();
        }
        else
        {
            Response.Redirect("/asp/error/404.aspx");
        }
    }
}