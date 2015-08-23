using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Security;

public partial class asp_Register : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void BtnRegister_Click(object sender, EventArgs e)
    {

    }

    [WebMethod(true)]
    public static string SubmitRegister(string UserName, string Email, string Password)
    {
        try
        {
            // 插入新用户数据
            MembershipUser newUser = Membership.CreateUser(UserName, Password, Email);
            // 将新用户默认加入 member 角色
            Roles.AddUserToRole(UserName, "member");
            return "{status:1}";
        }
        catch (MembershipCreateUserException e)
        {
            return "{status:-1,msg:'" + e.Message + "'}";
        }
    }

}