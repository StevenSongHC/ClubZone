using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class asp_ActivityNavi : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["CZConnectionString"].ConnectionString;
        SqlConnection conn = new SqlConnection(connString);
        conn.Open();
        string queryString = "Select Activity.Content,Activity.PublishDate,Club.Name As ClubName From Activity,Club Where Club.Id=Activity.ClubId Order By Activity.PublishDate Desc";
        SqlCommand cmd = new SqlCommand(queryString, conn);
        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
        DataSet ds = new DataSet();
        adapter.Fill(ds, "Activities");
        PagedDataSource pds = new PagedDataSource();
        pds.DataSource = ds.Tables["Activities"].DefaultView;
        pds.AllowPaging = true;
        pds.PageSize = 7;
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
            Response.Redirect("/asp/ActivityNavi.aspx?page=" + PageCount + "#new-activity-list");
        }
        if (CurrentPage < 1)
        {
            Response.Redirect("/asp/ActivityNavi.aspx?page=1#new-activity-list");
        }
        if (CurrentPage == 1)
        {
            PreviousPage.Visible = false;
        }
        if (CurrentPage == PageCount)
        {
            NextPage.Visible = false;
        }
        PreviousPage.NavigateUrl = "/asp/ActivityNavi.aspx?page=" + (CurrentPage - 1) + "#new-activity-list";
        NextPage.NavigateUrl = "/asp/ActivityNavi.aspx?page=" + (CurrentPage + 1) + "#new-activity-list";
        pds.CurrentPageIndex = CurrentPage - 1;
        Repeater1.DataSource = pds;
        Repeater1.DataBind();
    }
}