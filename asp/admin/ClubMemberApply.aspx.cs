using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data.SqlClient;
using System.Data;

public partial class asp_admin_ClubMemberApply : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // 不做验证
        int ClubId = Convert.ToInt32(Request.QueryString["clubid"].ToString());
        // 社团信息
        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["CZConnectionString"].ConnectionString;
        SqlConnection conn = new SqlConnection(connString);
        conn.Open();
        string queryString1 = "Select Name From Club Where Id=" + ClubId;
        SqlCommand cmd = new SqlCommand(queryString1, conn);
        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
        DataSet ds = new DataSet();
        adapter.Fill(ds, "ClubInfo");
        ClubNameTitleText.Text = ds.Tables["ClubInfo"].Rows[0]["Name"].ToString();
        ClubUrl.Text = ds.Tables["ClubInfo"].Rows[0]["Name"].ToString();
        ClubUrl.NavigateUrl = "/asp/club/View.aspx?name=" + ds.Tables["ClubInfo"].Rows[0]["Name"].ToString();

        // 成员列表
        string queryString2 = "Select ClubMember.*,U.UserName From ClubMember,aspnet_Users As U Where U.UserId=ClubMember.UserId And ClubId=" + ClubId;
        cmd = new SqlCommand(queryString2, conn);
        adapter = new SqlDataAdapter(cmd);
        ds = new DataSet();
        adapter.Fill(ds, "MemberList");
        Repeater1.DataSource = ds.Tables["MemberList"].DefaultView;
        Repeater1.DataBind();

        conn.Close();
    }

    [WebMethod(true)]
    public static string KillAllLeader(int ClubId)
    {
        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["CZConnectionString"].ConnectionString;
        SqlConnection conn = new SqlConnection(connString);
        conn.Open();
        // 将[上线]社团的所有人变成[成员]角色
        string queryString = "Update ClubMember Set IsLeader=0 Where ClubId=" + ClubId;
        SqlCommand cmd = new SqlCommand(queryString, conn);
        cmd.ExecuteNonQuery();

        conn.Close();

        return "{}";
    }

    [WebMethod(true)]
    public static string ApplyLeader(int ClubId, string UserId)
    {
        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["CZConnectionString"].ConnectionString;
        SqlConnection conn = new SqlConnection(connString);
        conn.Open();
        // 将[上线]社团的所有人变成[成员]角色
        string queryString = "Update ClubMember Set IsLeader=1 Where ClubId=" + ClubId + " And UserId='" + UserId + "'";
        SqlCommand cmd = new SqlCommand(queryString, conn);
        cmd.ExecuteNonQuery();

        conn.Close();

        return "{}";
    }

}