using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class asp_ArticleNavi : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["CZConnectionString"].ConnectionString;
        SqlConnection conn = new SqlConnection(connString);
        conn.Open();
        string queryString = "Select A.Id,A.Title,A.Content,A.PublishDate,U.UserName As PublisherUserName,Count(R.Id) As ReplyCount From Article As A Left Join Reply As R On R.ArticleId=A.Id,aspnet_Users As U Where U.UserId=A.UserId Group By A.Id,A.Title,A.Content,A.PublishDate,U.UserName Order By A.PublishDate Desc";
        SqlCommand cmd = new SqlCommand(queryString, conn);
        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
        DataSet ds = new DataSet();
        adapter.Fill(ds, "Articles");
        PagedDataSource pds = new PagedDataSource();
        pds.DataSource = ds.Tables["Articles"].DefaultView;
        pds.AllowPaging = true;
        pds.PageSize = 12;
        int PageCount = pds.PageCount;
        int CurrentPage;
        if (Request.QueryString["page"] != null && Request.QueryString["page"] != "")
        {
            CurrentPage = Convert.ToInt32(Request.QueryString["page"]);
        }
        else
        {
            CurrentPage = 1;
        }
        if (CurrentPage > PageCount)
        {
            Response.Redirect("/asp/ArticleNavi.aspx?page=" + PageCount + "#new-article-list");
        }
        if (CurrentPage < 1)
        {
            Response.Redirect("/asp/ArticleNavi.aspx?page=1#new-article-list");
        }
        if (CurrentPage == 1)
        {
            PreviousPage.Visible = false;
        }
        if (CurrentPage == PageCount)
        {
            NextPage.Visible = false;
        }
        PreviousPage.NavigateUrl = "/asp/ArticleNavi.aspx?page=" + (CurrentPage - 1) + "#new-article-list";
        NextPage.NavigateUrl = "/asp/ArticleNavi.aspx?page=" + (CurrentPage + 1) + "#new-article-list";
        pds.CurrentPageIndex = CurrentPage - 1;
        Repeater1.DataSource = pds;
        Repeater1.DataBind();
    }
}