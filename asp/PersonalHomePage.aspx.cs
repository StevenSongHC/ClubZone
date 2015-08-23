using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Data.SqlClient;
using System.Data;

public partial class asp_PersonalHomePage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // 获取登陆用户信息
        string UserId = Membership.GetUser().ProviderUserKey.ToString();

        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["CZConnectionString"].ConnectionString;
        SqlConnection conn = new SqlConnection(connString);
        conn.Open();
        // 获取[管理]的社团列表，以及其对应的会员、帖子、活动数（P.S.这sql真难写！！！）
        string queryString1 = "Select C.Id,C.Name,isnull(CMInfo.MemberCount,0) As MemberCount,isnull(ArtInfo.ArticleCount,0) As ArticleCount,isnull(ActInfo.ActivityCount,0) As ActivityCount From Club As C";
        queryString1 += " Left Join (Select CM.ClubId,Count(CM.UserId) As MemberCount From ClubMember As CM Group By CM.ClubId) As CMInfo On CMInfo.ClubId=C.Id";
        queryString1 += " Left Join (Select Art.ClubId,Count(Art.Id) As ArticleCount From Article As Art Group By Art.ClubId) As ArtInfo On ArtInfo.ClubId=C.Id";
        queryString1 += " Left Join (Select Act.ClubId,Count(Act.Id) As ActivityCount From Activity As Act Group By Act.ClubId) As ActInfo On ActInfo.ClubId=C.Id";
        queryString1 += " Where C.Id In (Select ClubId From ClubMember Where UserId='" + UserId + "' And IsLeader=1)";
        SqlCommand cmd = new SqlCommand(queryString1, conn);
        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
        DataSet ds = new DataSet();
        adapter.Fill(ds, "ManagerClubs");
        Repeater1.DataSource = ds.Tables["ManagerClubs"].DefaultView;
        Repeater1.DataBind();
        // 获取仅为[会员]的社团列表
        string queryString2 = "Select Name From Club Where Id In (Select ClubId From ClubMember Where UserId='" + UserId + "' And IsLeader=0)";
        cmd = new SqlCommand(queryString2, conn);
        adapter = new SqlDataAdapter(cmd);
        ds = new DataSet();
        adapter.Fill(ds, "MemberClubs");
        Repeater2.DataSource = ds.Tables["MemberClubs"].DefaultView;
        Repeater2.DataBind();

        // 获取最近发帖列表，只显示最近的3条（回复同）
        string queryString3 = "Select Top 3 Art.Id,Art.Title,Art.Content,Art.PublishDate,C.Name As ClubName,C.Photo As ClubPhoto From Article As Art,Club As C Where C.Id=Art.ClubId And Art.UserId='" + UserId + "' Order By PublishDate Desc";
        cmd = new SqlCommand(queryString3, conn);
        adapter = new SqlDataAdapter(cmd);
        ds = new DataSet();
        adapter.Fill(ds, "ShortArticleList");
        Repeater3.DataSource = ds.Tables["ShortArticleList"].DefaultView;
        Repeater3.DataBind();
        // 获取最近的回贴记录

        string queryString4 = "Select Top 3 Rly.Content,Rly.ReplyDate,Art.Id As ArticleId,Art.Title As ArticleTitle From Reply As Rly,Article As Art Where Art.Id=Rly.ArticleId And Rly.UserId='" + UserId + "' Order By ReplyDate Desc";
        cmd = new SqlCommand(queryString4, conn);
        adapter = new SqlDataAdapter(cmd);
        ds = new DataSet();
        adapter.Fill(ds, "ShortReplyList");
        Repeater4.DataSource = ds.Tables["ShortReplyList"].DefaultView;
        Repeater4.DataBind();

        conn.Close();
    }
}