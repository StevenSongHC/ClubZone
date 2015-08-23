using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Security;

public partial class asp_Logout : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(true)]
    public static string Logout()
    {
        FormsAuthentication.SignOut();
        return "{status:1}";
    }

}