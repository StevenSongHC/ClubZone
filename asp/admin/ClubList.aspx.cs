using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class asp_admin_ClubList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["CZConnectionString"].ConnectionString;
        // 根据传送的参数决定检索的数据条件
        string QueryCollection = Request.QueryString["query_collection"];
        int IsAllowed = 1;  // 默认不带相关参数时检索上线的数据 - 0=未审核，1=上线的，-1=管理员拒绝通过并加入黑名单的
        if (QueryCollection != null)
        {
            if (QueryCollection == "online")
            {
                IsAllowed = 1;
            }
            else if (QueryCollection == "uncensored")
            {
                IsAllowed = 0;
            }
            else if (QueryCollection == "blacklist")
            {
                IsAllowed = -1;
            }
            // 传送的query_collection参数非法，重定向到“参数非法页面，懒得再重定向到一个带有合法纠正参数的页面”
            else
            {
                Response.Redirect("/asp/error/IllegalParam.aspx");
            }
        }
        string queryString = "Select * From Club Where IsAllowed=" + IsAllowed;
        SqlConnection conn = new SqlConnection(connString);
        conn.Open();
        SqlCommand cmd = new SqlCommand(queryString, conn);
        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
        DataSet ds = new DataSet();
        adapter.Fill(ds);
        // 分页实现，每页显示十条记录
        PagedDataSource pds = new PagedDataSource();
        pds.DataSource = ds.Tables[0].DefaultView;
        pds.AllowPaging = true;
        pds.PageSize = 10;

        int PageCount = pds.PageCount;      // 总页数
        // 读取请求打开页数的参数
        int CurrentPage;
        if (Request.QueryString["page"] != null)
        {
            CurrentPage = Convert.ToInt32(Request.QueryString["page"]);
        }
        else
        {
            CurrentPage = 1;
        }

        // 页数大于总页数或小于1时，分别重定向到最后一页和第一页
        if (CurrentPage > PageCount)
        {
            Response.Redirect("/asp/admin/ClubList.aspx?" + (QueryCollection != null ? "query_collection=" + QueryCollection + "&" : "") + "page=" + PageCount);
        }
        if (CurrentPage < 1)
        {
            Response.Redirect("/asp/admin/ClubList.aspx?" + (QueryCollection != null ? "query_collection=" + QueryCollection + "&" : "") + "page=1");
        }

        // 当当前页数为第一页时，隐藏“上一页”链接
        if (CurrentPage == 1)
        {
            PreviousPage.Visible = false;
        }
        // 为最后一页时隐藏“下一页”链接
        if (CurrentPage == PageCount)
        {
            NextPage.Visible = false;
        }

        // 设置“上一页”和“下一页”的链接，由于开头有页数限制验证，可以乱来！！
        PreviousPage.NavigateUrl = "/asp/admin/ClubList.aspx?" + (QueryCollection != null ? "query_collection=" + QueryCollection + "&" : "") + "page=" + (CurrentPage - 1);
        NextPage.NavigateUrl = "/asp/admin/ClubList.aspx?" + (QueryCollection != null ? "query_collection=" + QueryCollection + "&" : "") + "page=" + (CurrentPage + 1);

        // 显示的页数数据
        pds.CurrentPageIndex = CurrentPage - 1;

        // 显示对应请求的数据列表
        if (QueryCollection != null)
        {
            // 在“上线的社团”表中显示数据
            if (QueryCollection == "online")
            {
                Repeater1.DataSource = pds;
                Repeater1.DataBind();
            }
            // 在“未审核”表中显示数据
            else if (QueryCollection == "uncensored")
            {
                Repeater2.DataSource = pds;
                Repeater2.DataBind();
            }
            // 在“黑名单”表中显示数据
            else
            {
                Repeater3.DataSource = pds;
                Repeater3.DataBind();
            }
        }
        // 不带该参数默认在“上线的社团”表中显示数据
        else
        {
            Repeater1.DataSource = pds;
            Repeater1.DataBind();
        }

        conn.Close();
    }
}