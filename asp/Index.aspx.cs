using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Data.SqlClient;
using System.Data;

public partial class asp_Index : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // 默认不显示“善意”提醒消息
        HeadUp.Visible = false;
        // 初始数据库操作
        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["CZConnectionString"].ConnectionString;
        SqlConnection conn = new SqlConnection(connString);
        conn.Open();
        SqlCommand cmd;
        SqlDataAdapter adapter;
        DataSet ds;
        // 先判断用户是否登陆
        // 未登录，在首页显示最新的创建的社团、帖子、活动，是这些内容更好地被发现
        if (!User.Identity.IsAuthenticated)
        {
            // 检索前7个新建社团
            string queryString1 = "Select Top 7 Name From Club Where IsAllowed=1 Order By FoundDate Desc";
            cmd = new SqlCommand(queryString1, conn);
            adapter = new SqlDataAdapter(cmd);
            ds = new DataSet();
            adapter.Fill(ds, "NewClubList");
            Repeater1.DataSource = ds.Tables["NewClubList"].DefaultView;
            Repeater1.DataBind();
            // 检索前15条帖子
            string queryString2 = "Select Top 15 Article.Id,Article.Title,Club.Name As ClubName,Club.Photo As ClubPhoto From Article,Club Where Club.Id=Article.ClubId Order By Article.PublishDate Desc";
            cmd = new SqlCommand(queryString2, conn);
            adapter = new SqlDataAdapter(cmd);
            ds = new DataSet();
            adapter.Fill(ds, "NewArticleList");
            Repeater2.DataSource = ds.Tables["NewArticleList"].DefaultView;
            Repeater2.DataBind();
            // 检索前10条活动
            string queryString3 = "Select Top 10 Activity.Content,Activity.PublishDate,Club.Name As ClubName From Activity,Club Where Club.Id=Activity.ClubId Order By Activity.PublishDate Desc";
            cmd = new SqlCommand(queryString3, conn);
            adapter = new SqlDataAdapter(cmd);
            ds = new DataSet();
            adapter.Fill(ds, "NewActivityList");
            Repeater3.DataSource = ds.Tables["NewActivityList"].DefaultView;
            Repeater3.DataBind();
        }
        // 已登陆用户，在判断有加入社团之后，会检索所加入社团的靠前相关数据
        else
        {
            string UserId = Membership.GetUser().ProviderUserKey.ToString();
            // 获得加入社团信息
            string queryString4 = "Select * From ClubMember Where UserId='" + UserId + "'";
            cmd = new SqlCommand(queryString4, conn);
            adapter = new SqlDataAdapter(cmd);
            ds = new DataSet();
            adapter.Fill(ds, "JoinedClubs");
            // 记录数为空说明还未加入任何社团
            if (ds.Tables["JoinedClubs"].Rows.Count == 0)
            {
                // “善意”的提醒
                HeadUp.Visible = true;
                // 洗洗睡吧
                conn.Close();
                return;
            }
            // 各个数据信息同上上
            string queryString1 = "Select Top 7 Name From Club Where Id In (Select ClubId From ClubMember Where UserId='" + UserId + "') Order By FoundDate Desc";
            cmd = new SqlCommand(queryString1, conn);
            adapter = new SqlDataAdapter(cmd);
            ds = new DataSet();
            adapter.Fill(ds, "NewClubList");
            Repeater1.DataSource = ds.Tables["NewClubList"].DefaultView;
            Repeater1.DataBind();
            // 检索前15条帖子
            string queryString2 = "Select Top 15 Article.Id,Article.Title,Club.Name As ClubName,Club.Photo As ClubPhoto From Article,Club Where Club.Id=Article.ClubId And Article.ClubId In (Select ClubId From ClubMember Where UserId='" + UserId + "') Order By Article.PublishDate Desc";
            cmd = new SqlCommand(queryString2, conn);
            adapter = new SqlDataAdapter(cmd);
            ds = new DataSet();
            adapter.Fill(ds, "NewArticleList");
            Repeater2.DataSource = ds.Tables["NewArticleList"].DefaultView;
            Repeater2.DataBind();
            // 检索前10条活动
            string queryString3 = "Select Top 10 Activity.Content,Activity.PublishDate,Club.Name As ClubName From Activity,Club Where Activity.ClubId In (Select ClubId From ClubMember Where UserId='" + UserId + "') And Club.Id=Activity.ClubId Order By Activity.PublishDate Desc";
            cmd = new SqlCommand(queryString3, conn);
            adapter = new SqlDataAdapter(cmd);
            ds = new DataSet();
            adapter.Fill(ds, "NewActivityList");
            Repeater3.DataSource = ds.Tables["NewActivityList"].DefaultView;
            Repeater3.DataBind();
        }

        conn.Close();
    }
}