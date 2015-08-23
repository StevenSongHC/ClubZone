using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data.SqlClient;
using System.Data;

public partial class asp_admin_ReviewClub : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // 读取id，为空就转入错误页
        if (Request.QueryString["id"] == null)
        {
            Response.Redirect("/asp/error/IllegalParam.aspx");
        }
        else
        {
            int Id = Convert.ToInt32(Request.QueryString["id"].ToString());
            string connString = System.Configuration.ConfigurationManager.ConnectionStrings["CZConnectionString"].ConnectionString;
            string queryString = "Select C.Id,C.Name,C.Photo,C.Intro,C.FoundDate,U.UserName From Club As C,ClubMember As CM Left Join aspnet_Users As U On U.UserId=CM.UserId Where C.Id=" + Id + " And CM.ClubId=C.Id";
            SqlConnection conn = new SqlConnection(connString);
            conn.Open();
            SqlCommand cmd = new SqlCommand(queryString, conn);
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            adapter.Fill(ds);

            ClubId.Text = ds.Tables[0].Rows[0][0].ToString();
            ClubName.Text = ds.Tables[0].Rows[0][1].ToString();
            ClubPhoto.ImageUrl = ds.Tables[0].Rows[0][2].ToString();
            ClubIntro.Text = ds.Tables[0].Rows[0][3].ToString();
            SubmitDate.Text = ds.Tables[0].Rows[0][4].ToString();
            LeaderUserName.Text = ds.Tables[0].Rows[0][5].ToString();

            conn.Close();
        }
    }

    [WebMethod(true)]
    public static string SubmitReview(int Id, int IsAllowed)
    {
        // 当参数不为“同意1”或“拒绝-1”时，返回错误状态码
        if (IsAllowed != 1 && IsAllowed != -1)
            return "{status:-1}";
        // 不做参数Id是否有效的检测了，因为这是管理员Only方法，没必要浪费时间
        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["CZConnectionString"].ConnectionString;
        string queryString = "Update Club Set IsAllowed=" + IsAllowed + " Where Id=" + Id;
        SqlConnection conn = new SqlConnection(connString);
        conn.Open();
        SqlCommand cmd = new SqlCommand(queryString, conn);
        cmd.ExecuteNonQuery();

        conn.Close();

        return "{status:1}";
    }

}