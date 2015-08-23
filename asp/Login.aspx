<%@ Page Title="" Language="C#" MasterPageFile="~/asp/Common.master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="asp_Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" Runat="Server">
    <title>用户登陆 | 社团空间</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="StyleFile" Runat="Server">
    <link href="/css/register-login.css" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptFile" Runat="Server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="Style" Runat="Server">
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="Script" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#input-username").focus();
            $("#login-form").keydown(function (e) {
                if (e.keyCode == 13)
                    login();
            });

            // 在前端实现RedirectToLoginPage
            if ("<%= Request.QueryString["ReturnUrl"] %>".length > 1)
                ReturnUrl = "<%= Request.QueryString["ReturnUrl"] %>"
            else
                ReturnUrl = "/";      // 主页
        });

        function login() {
            var UserName = $("#input-username").val().trim();
            var Password = $("#input-password").val();
            var RememberMe = false;
            // 检查是否勾上“记住我”的选项         P.S.真奇葩的.Net
            if ($("#remember-me:checked").val() == "on")
                RememberMe = true;
            console.log(RememberMe);
            if (UserName.length < 1) {
                alert("用户名还没输入呢");
                $("#input-username").focus();
            }
            else {
                if (Password.length < 1) {
                    alert("密码为空！！！");
                    $("#input-password").focus();
                }
                else {
                    $.ajax({
                        url: "/asp/Login.aspx/SubmitLogin",
                        type: "POST",
                        dataType: "JSON",
                        contentType: "application/json; charset=utf-8",
                        data: "{UserName:'" + UserName + "',Password:'" + Password + "',RememberMe:" + RememberMe + "}"
                    }).done(function (result) {
                        var json = eval("(" + result.d + ")");
                        switch (json.status) {
                            case 1:         // 登陆成功后转向ReturnUrl
                                window.location.href = ReturnUrl;
                                break;
                            case -1:        // 登陆失败，提示错误信息
                                alert("用户名或密码错误");
                                break;
                            default:        // 未与服务器通信成功
                                alert("未知错误");
                        }
                    }).fail(function () {
                        alert("fail");
                    });
                }
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:CZConnectionString %>" SelectCommand="SELECT * FROM [user]"></asp:SqlDataSource>
    <form id="login-form" class="form-horizontal">
        <div class="form-group">
            <label for="input-username" class="col-sm-2 control-label">用户名</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="input-username" placeholder="请输入用户名" />
            </div>
        </div>
        <div class="form-group">
            <label for="input-password" class="col-sm-2 control-label">密码</label>
            <div class="col-sm-10">
                <input type="password" class="form-control" id="input-password" placeholder="请输入密码" />
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">
                <div class="checkbox">
                    <label>
                        <input id="remember-me" type="checkbox" />记住我
                    </label>
                </div>
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">
                <button type="button" class="btn btn-info" onclick="javascript:login()">登陆</button>
                <a href="/asp/Register.aspx" style="float:right;">注册新的账号</a>
            </div>
        </div>
    </form>
</asp:Content>

