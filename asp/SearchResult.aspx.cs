using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class asp_SearchResult : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // 判断是否参数合法
        if (Request.QueryString["type"] == null || Request.QueryString["keyword"] == null)
        {
            Response.Redirect("/asp/error/IllegalParam.aspx");
        }

        string Type = Request.QueryString["type"];
        string Keyword = Request.QueryString["keyword"];

        // 操作数据库
        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["CZConnectionString"].ConnectionString;
        SqlConnection conn = new SqlConnection(connString);
        conn.Open();
        // 选择检索的类型
        if (Type == "社团")
        {
            // 先查询返回的记录数，再决定后面是否有必要查询数据列表
            string queryString1 = "Select Count(Club.Id) As ResultCount From Club Where Name Like N'" + Keyword + "%' And IsAllowed=1";        // 中文要在前加 N !!!
            SqlCommand cmd = new SqlCommand(queryString1, conn);
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            adapter.Fill(ds);
            // 有匹配的数据
            if (Convert.ToInt32(ds.Tables[0].Rows[0]["ResultCount"].ToString()) > 0)
            {
                // 显示记录数
                ResultCount.Text = ds.Tables[0].Rows[0]["ResultCount"].ToString();
                // 再查询符合条件的记录   （P.S.参照个人页面PersonalHomePage.aspx中检索管理社团数据统计的sql，挺复杂的...我认为）
                string queryString2 = "Select C.Name,C.Photo,C.Intro,isnull(CMInfo.MemberCount,0) As MemberCount,isnull(ArtInfo.ArticleCount,0) As ArticleCount,isnull(ActInfo.ActivityCount,0) As ActivityCount From Club As C";
                queryString2 += " Left Join (Select CM.ClubId,Count(CM.UserId) As MemberCount From ClubMember As CM Group By CM.ClubId) As CMInfo On CMInfo.ClubId=C.Id";
                queryString2 += " Left Join (Select Art.ClubId,Count(Art.Id) As ArticleCount From Article As Art Group By Art.ClubId) As ArtInfo On ArtInfo.ClubId=C.Id";
                queryString2 += " Left Join (Select Act.ClubId,Count(Act.Id) As ActivityCount From Activity As Act Group By Act.ClubId) As ActInfo On ActInfo.ClubId=C.Id";
                queryString2 += " Where C.Id In (Select ClubId From ClubMember Where Name Like N'" + Keyword + "%' And IsAllowed=1)";
                cmd = new SqlCommand(queryString2, conn);
                adapter = new SqlDataAdapter(cmd);
                ds.Clear();     // 不清空DataSet不知怎样设置PageDataSource的数据源
                adapter.Fill(ds);
                // 分页显示，具体细节可参看ClubList.aspx中的注释
                PagedDataSource pds = new PagedDataSource();
                pds.DataSource = ds.Tables[0].DefaultView;
                pds.AllowPaging = true;
                pds.PageSize = 10;
                int PageCount = pds.PageCount;
                int CurrentPage;
                if (Request.QueryString["page"] != null)
                {
                    CurrentPage = Convert.ToInt32(Request.QueryString["page"]);
                }
                else
                {
                    CurrentPage = 1;
                }
                if (CurrentPage > PageCount)
                {
                    Response.Redirect("/asp/SearchResult.aspx?type=" + Type + "&keyword=" + Keyword + "&page=" + PageCount);
                }
                if (CurrentPage < 1)
                {

                    Response.Redirect("/asp/SearchResult.aspx?type=" + Type + "&keyword=" + Keyword + "&page=1");
                }
                if (CurrentPage == 1)
                {
                    PreviousPage.Visible = false;
                }
                if (CurrentPage == PageCount)
                {
                    NextPage.Visible = false;
                }
                PreviousPage.NavigateUrl = "/asp/SearchResult.aspx?type=" + Type + "&keyword=" + Keyword + "&page=" + (CurrentPage - 1);
                NextPage.NavigateUrl = "/asp/SearchResult.aspx?type=" + Type + "&keyword=" + Keyword + "&page=" + (CurrentPage + 1);
                // 终于到显示啦
                pds.CurrentPageIndex = CurrentPage - 1;
                Repeater1.DataSource = pds;
                Repeater1.DataBind();
            }
            // 无相关记录
            else
            {
                // 直接显示空记录信息
                ResultCount.Text = "0";
                // 隐藏分页导航按钮
                PreviousPage.Visible = false;
                NextPage.Visible = false;
                // 貌似VS出bug了，前台控件无法获取，那就这样了...

            }
        }
        else if (Type == "帖子")
        {
            // 若没初始化clubid，就报错
            if (Request.QueryString["clubname"] == null || Request.QueryString["clubname"] == "")
            {
                Response.Redirect("/asp/error/IllegalParam.aspx");
                return;
            }
            string ClubName = Request.QueryString["clubname"].ToString();








            string queryString1 = "Select Count(Article.Id) As ResultCount From Article Where Title Like N'" + Keyword + "%' And ClubId=(Select Id From Club Where Name=N'" + ClubName + "')";        // 中文要在前加 N !!!
            SqlCommand cmd = new SqlCommand(queryString1, conn);
            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            adapter.Fill(ds);
            if (Convert.ToInt32(ds.Tables[0].Rows[0]["ResultCount"].ToString()) > 0)
            {
                ResultCount.Text = ds.Tables[0].Rows[0]["ResultCount"].ToString();
                string queryString2 = "Select Art.Id,Art.Title,Art.Content,Art.PublishDate,U.UserName As PublisherUserName From Article As Art,aspnet_Users As U";
                queryString2 += " Where U.UserId=Art.UserId And Art.ClubId=(Select Id From Club Where Name=N'" + ClubName + "' And IsAllowed=1) And Art.Title Like N'" + Keyword + "%'";
                cmd = new SqlCommand(queryString2, conn);
                adapter = new SqlDataAdapter(cmd);
                ds.Clear();
                adapter.Fill(ds);
                PagedDataSource pds = new PagedDataSource();
                pds.DataSource = ds.Tables[0].DefaultView;
                pds.AllowPaging = true;
                pds.PageSize = 10;
                int PageCount = pds.PageCount;
                int CurrentPage;
                if (Request.QueryString["page"] != null)
                {
                    CurrentPage = Convert.ToInt32(Request.QueryString["page"]);
                }
                else
                {
                    CurrentPage = 1;
                }
                if (CurrentPage > PageCount)
                {
                    Response.Redirect("/asp/SearchResult.aspx?type=" + Type + "&keyword=" + Keyword + "&clubname=" + ClubName + "&page=" + PageCount);
                }
                if (CurrentPage < 1)
                {

                    Response.Redirect("/asp/SearchResult.aspx?type=" + Type + "&keyword=" + Keyword + "&clubname=" + ClubName + "&page=1");
                }
                if (CurrentPage == 1)
                {
                    PreviousPage.Visible = false;
                }
                if (CurrentPage == PageCount)
                {
                    NextPage.Visible = false;
                }
                PreviousPage.NavigateUrl = "/asp/SearchResult.aspx?type=" + Type + "&keyword=" + Keyword + "&clubname=" + ClubName + "&page=" + (CurrentPage - 1);
                NextPage.NavigateUrl = "/asp/SearchResult.aspx?type=" + Type + "&keyword=" + Keyword + "&clubname=" + ClubName + "&page=" + (CurrentPage + 1);
                pds.CurrentPageIndex = CurrentPage - 1;
                Repeater2.DataSource = pds;
                Repeater2.DataBind();
            }
            // 无相关记录
            else
            {
                // 直接显示空记录信息
                ResultCount.Text = "0";
                // 隐藏分页导航按钮
                PreviousPage.Visible = false;
                NextPage.Visible = false;

            }








        }
        else
        {
            Response.Redirect("/asp/error/IllegalParam.aspx");
        }

        // release
        conn.Close();
    }
}