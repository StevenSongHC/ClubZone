<%@ Page Title="" Language="C#" MasterPageFile="~/asp/Common.master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="asp_Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" Runat="Server">
    <title>用户注册 | 社团空间</title>
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
            // 默认聚焦用户名输入框
            $("#input-username").focus();
            // 绑定回车按下事件
            $("#register-form").keydown(function (e) {
                if (e.keyCode == 13)
                    registerUser();
            });
        });

        function registerUser() {
            var UserName = $("#input-username").val().trim();
            var Email = $("#input-email").val().trim()
            var Password = $("#input-password").val();
            var ConfirmPassword = $("#input-confirm-password").val();
            if (UserName.length < 6) {
                alert("用户名长度至少要6位");
                $("#input-username").focus();
            }
            else {
                if (Email.length < 1) {
                    alert("邮箱不得为空");
                    $("#input-email").focus();
                }
                else {
                    var EmailReg = /^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/;
                    if (!EmailReg.test(Email)) {
                        alert("输入的邮箱格式不正确");
                        $("#input-email").focus();
                    }
                    else {
                        if (Password.length < 6) {
                            alert("密码长度至少要6位");
                            $("#input-password").focus();
                        }
                        else {
                            if (ConfirmPassword !== Password) {
                                alert("两次输入的密码不一致");
                                $("#input-confirm-password").focus();
                            }
                            else {
                                $.ajax({
                                    url: "/asp/Register.aspx/SubmitRegister",
                                    type: "POST",
                                    dataType: "JSON",
                                    contentType: "application/json; charset=utf-8",
                                    // 奇葩！！！
                                    data: "{UserName:'" + UserName + "',Email:'" + Email + "',Password:'" + Password + "'}"
                                }).done(function (result) {
                                    var json = eval("(" + result.d + ")");
                                    switch (json.status) {
                                        case 1:         // 注册成功后转向登陆页
                                            alert("注册成功");
                                            window.location.href = "/asp/Login.aspx";
                                            break;
                                        case -1:        // 注册失败，提示MembershipCreateStatus提供的错误信息
                                            alert(json.msg);
                                            break;
                                        default:        // 未与服务器通信成功
                                            alert("未知错误");
                                    }
                                }).fail(function () {
                                    alert("fail");
                                }).error(function (XMLHttpRequest, textStatus, errorThrown) {
                                    alert(textStatus);
                                });
                            }
                        }
                    }
                }
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:CZConnectionString %>" SelectCommand="SELECT * FROM [user]"></asp:SqlDataSource>
    <form id="register-form" class="form-horizontal">
        <div class="form-group">
            <label for="input-username" class="col-sm-2 control-label">用户名</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="input-username" placeholder="请输入用户名" />
            </div>
        </div>
        <div class="form-group">
            <label for="input-email" class="col-sm-2 control-label">邮箱</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="input-email" placeholder="请填入正确的邮箱" />
            </div>
        </div>
        <div class="form-group">
            <label for="input-password" class="col-sm-2 control-label">密码</label>
            <div class="col-sm-10">
                <input type="password" class="form-control" id="input-password" placeholder="请输入密码" />
            </div>
        </div>
        <div class="form-group">
            <label for="input-confirm-password" class="col-sm-2 control-label">重复密码</label>
            <div class="col-sm-10">
                <input type="password" class="form-control" id="input-confirm-password" placeholder="请再输入一次密码" />
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">
                <button type="button" class="btn btn-info" onclick="javascript:registerUser()">注册</button>
                <a href="/asp/Login.aspx" style="float:right;">已有账号，点此登陆</a>
            </div>
        </div>
    </form>
</asp:Content>

