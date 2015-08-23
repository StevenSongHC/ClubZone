using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class asp_ClubNavi : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["CZConnectionString"].ConnectionString;
        SqlConnection conn = new SqlConnection(connString);
        conn.Open();
        string queryString = "Select C.Name,C.Photo,C.Intro,isnull(CMInfo.MemberCount,0) As MemberCount,isnull(ArtInfo.ArticleCount,0) As ArticleCount,isnull(ActInfo.ActivityCount,0) As ActivityCount From Club As C";
        queryString += " Left Join (Select CM.ClubId,Count(CM.UserId) As MemberCount From ClubMember As CM Group By CM.ClubId) As CMInfo On CMInfo.ClubId=C.Id";
        queryString += " Left Join (Select Art.ClubId,Count(Art.Id) As ArticleCount From Article As Art Group By Art.ClubId) As ArtInfo On ArtInfo.ClubId=C.Id";
        queryString += " Left Join (Select Act.ClubId,Count(Act.Id) As ActivityCount From Activity As Act Group By Act.ClubId) As ActInfo On ActInfo.ClubId=C.Id";
        queryString += " Where C.IsAllowed=1 Order By C.FoundDate Desc";
        SqlCommand cmd = new SqlCommand(queryString, conn);
        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
        DataSet ds = new DataSet();
        adapter.Fill(ds);
        PagedDataSource pds = new PagedDataSource();
        pds.DataSource = ds.Tables[0].DefaultView;
        pds.AllowPaging = true;
        pds.PageSize = 10;
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
            Response.Redirect("/asp/ClubNavi.aspx?page=" + PageCount + "#new-club-list");
        }
        if (CurrentPage < 1)
        {

            Response.Redirect("/asp/ClubNavi.aspx?page=1#new-club-list");
        }
        if (CurrentPage == 1)
        {
            PreviousPage.Visible = false;
        }
        if (CurrentPage == PageCount)
        {
            NextPage.Visible = false;
        }
        PreviousPage.NavigateUrl = "/asp/ClubNavi.aspx?page=" + (CurrentPage - 1) + "#new-club-list";
        NextPage.NavigateUrl = "/asp/ClubNavi.aspx?page=" + (CurrentPage + 1) + "#new-club-list";
        pds.CurrentPageIndex = CurrentPage - 1;
        Repeater1.DataSource = pds;
        Repeater1.DataBind();
    }
}