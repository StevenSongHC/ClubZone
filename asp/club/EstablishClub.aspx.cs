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

public partial class asp_EstablishClub : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string ClubName = Request.QueryString["club_name"];
        // 新建的社团名字为空
        if (ClubName.Length < 1)
            Response.Redirect("/asp/error/IllegalParam.aspx");
    }

    [WebMethod(true)]
    public static string SubmitEstablishment(string ClubName, string ClubIntro)
    {
        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["CZConnectionString"].ConnectionString;
        string queryString1 = "Select * From Club Where Name=N'" + ClubName + "'";        // 查询是否已有名字相同的社团存在
        SqlConnection conn = new SqlConnection(connString);
        conn.Open();
        SqlCommand cmd = new SqlCommand(queryString1, conn);
        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
        DataSet ds = new DataSet();
        adapter.Fill(ds);
        int status = -1;
        if (ds.Tables[0].Rows.Count > 0)        // 已有名字相同的社团存在
        {
            status = -2;
        }
        else                                    // 可以新建立
        {
            // 插入新社团
            string queryString2 = "Insert Into [Club](Name,Intro,FoundDate) Values (N'" + ClubName + "',N'" + ClubIntro +  "','" + DateTime.Now.ToString() + "')";
            cmd = new SqlCommand(queryString2, conn);
            cmd.ExecuteNonQuery();
            // 查看是否插入成功，通过之前查找相同名字社团数量的方法，不为0则成功
            cmd = new SqlCommand(queryString1, conn);
            adapter = new SqlDataAdapter(cmd);
            adapter.Fill(ds);
            if (ds.Tables[0].Rows.Count > 0)    // 插入成功
            {
                // 将申请者默认作为该社团的吧主
                string queryString3 = "Insert Into [ClubMember] Values ((Select Id From Club Where Name=N'" + ClubName + "'),'" + Membership.GetUser().ProviderUserKey + "',1,'" + DateTime.Now.ToString() + "')";
                cmd = new SqlCommand(queryString3, conn);
                cmd.ExecuteNonQuery();

                status = 1;
            }
            else                                // 失败
            {
                status = -1;
            }
        }
        conn.Close();

        return "{status:" + status + "}";
    }

}