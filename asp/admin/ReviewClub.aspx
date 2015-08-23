<%@ Page Title="" Language="C#" MasterPageFile="~/asp/Common.master" AutoEventWireup="true" CodeFile="ReviewClub.aspx.cs" Inherits="asp_admin_ReviewClub" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" Runat="Server">
    <title>审核新建的社团 | 社团空间</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleFile" Runat="Server">
    <link href="/css/review-club.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptFile" Runat="Server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="Style" Runat="Server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="Script" Runat="Server">
    <script type="text/javascript">
        function submitReview(IsAllowed) {
            // 当用控制台修改成非法参数时，不做任何操作（管理员不会那么无聊吧）
            if (undefined == IsAllowed || (IsAllowed != 1 && IsAllowed != -1))
                return;
            $.ajax({
                url: "/asp/admin/ReviewClub.aspx/SubmitReview",
                type: "POST",
                dataType: "JSON",
                contentType: "application/json; charset=utf-8",
                data: "{Id:" + <%= Request.QueryString["id"] %> + ",IsAllowed:" + IsAllowed + ",LeaderUserName:'" + $("#leader-username").html() + "'}"
            }).done(function (result) {
                var json = eval("(" + result.d + ")");
                switch (json.status) {
                    case 1:         // 成功审核后关闭页面
                        alert("审核完成：" + IsAllowed);
                        window.close();
                        break;
                    case 0:         // pop alert message then refresh
                        alert("审核的Id指向不存在的社团!");
                        window.location.reload();
                        break;
                    case -1:        // redirect to error page
                        window.location.href = "/asp/error/IllegalParam.aspx";
                        break;
                    default:        // 未与服务器通信成功
                        alert("未知错误");
                }
            }).fail(function () {
                alert("fail");
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="top">
        <div class="photo">
            <asp:Image ID="ClubPhoto" AlternateText="社团默认图标" runat="server"  />
        </div>
        <div class="info">
            <h2>
                <abbr title="社团Id编号" class="initialism"><em><asp:Literal ID="ClubId" runat="server"></asp:Literal></em></abbr>
                <asp:Literal ID="ClubName" runat="server"></asp:Literal>
            </h2>
            <div class="submitter">
                <h3>
                    <abbr id="leader-username" title="申请者（吧主）"><asp:Literal ID="LeaderUserName" runat="server"></asp:Literal></abbr><small> - <asp:Literal ID="SubmitDate" runat="server"></asp:Literal></small>
                </h3>
            </div>
        </div>
    </div>
    <div class="bottom">
        <div class="operation">
            <button type="button" class="btn btn-success btn-lg" onclick="javascript:submitReview(1)">同意</button>
            <button type="button" class="btn btn-warning btn-lg" onclick="javascript:submitReview(-1)">拒绝</button>
        </div>
        <div class="intro">
            <blockquote>
                <asp:Literal ID="ClubIntro" runat="server"></asp:Literal>
           </blockquote>
        </div>
        <div style="clear: both;"></div>
    </div>
</asp:Content>

