using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Security;

public partial class asp_Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //  若已登陆，转到首页
        if (User.Identity.IsAuthenticated)
            Response.Redirect("../");
    }

    protected void BtnLogin_Click(object sender, EventArgs e)
    {
        
    }

    [WebMethod(true)]
    public static string SubmitLogin(string UserName, string Password, bool RememberMe)
    {
        // 用户验证成功
        if (Membership.ValidateUser(UserName, Password))
        {
            FormsAuthentication.SetAuthCookie(UserName, RememberMe);
            return "{status:1}";
        }
        // 用户验证失败
        return "{status:-1}";
    }

}