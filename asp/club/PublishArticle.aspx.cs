using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Data.SqlClient;
using System.Data;

public partial class asp_club_PublishArticle : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // 后台在验证一次提交数据是否合法
        if (Request.QueryString["input-title"].ToString() == null || Request.QueryString["input-content"].ToString() == null || Request.QueryString["clubname"].ToString() == null || Request.QueryString["input-title"].ToString() == "" || Request.QueryString["input-content"].ToString() == "" || Request.QueryString["input-title"].ToString() == "")
        {
            Response.Redirect("/asp/error/IllegalParam.aspx");
        }
        string Title = Request.QueryString["input-title"].ToString();
        string Content = Request.QueryString["input-content"].ToString();
        string ClubName = Request.QueryString["clubname"].ToString();

        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["CZConnectionString"].ConnectionString;
        SqlConnection conn = new SqlConnection(connString);
        conn.Open();
        // 会员才能在此发帖
        string queryString1 = "Select * From ClubMember Where ClubId=(Select Id From Club Where Name=N'" + ClubName + "') And UserId='" + Membership.GetUser().ProviderUserKey + "'";
        SqlCommand cmd = new SqlCommand(queryString1, conn);
        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
        DataSet ds = new DataSet();
        adapter.Fill(ds);
        // 返回列数为空说明不是会员
        if (ds.Tables[0].Rows.Count == 0)
        {
            // 警告并重定向
            Response.Write("<script>alert('请先成为会员再发帖');window.location.href='/asp/club/View.aspx?name=" + ClubName + "';</script>");
        }
        // 查到会员记录
        else
        {
            string queryString2 = "Insert Into Article Values ('" + Membership.GetUser().ProviderUserKey + "',(Select Id From Club Where Name=N'" + ClubName + "'),N'" + Title + "',N'" + Content + "','" + DateTime.Now.ToString() + "')";
            cmd = new SqlCommand(queryString2, conn);
            cmd.ExecuteNonQuery();
            // 完成回到社团首页，好找新发布的帖子
            Response.Write("<script>window.location.href='/asp/club/View.aspx?name=" + ClubName + "';</script>");
        }

        conn.Close();
    }

}