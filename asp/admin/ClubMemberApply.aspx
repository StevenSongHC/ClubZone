<%@ Page Title="" Language="C#" MasterPageFile="~/asp/Common.master" AutoEventWireup="true" CodeFile="ClubMemberApply.aspx.cs" Inherits="asp_admin_ClubMemberApply" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" Runat="Server">
    <title>[<asp:Literal ID="ClubNameTitleText" runat="server" />]吧主管理 | 社团空间</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleFile" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptFile" Runat="Server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="Style" Runat="Server">
    <style type="text/css">
        #main {
            margin: auto;
            width: 50%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="Script" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            // “保护”唯一的那个吧主
            if ($("input[name='leader']:checked").length < 2) {
                $("input[name='leader']:checked").attr("disabled", true);
            }
            // 确保至少有一个选中
            $("input[name='leader']").click(function () {
                // protect
                if ($("input[name='leader']:checked").length < 2) {
                    $("input[name='leader']:checked").attr("disabled", true);
                }
                // 放开不可选择限制
                else {
                    $("input[name='leader']:checked").attr("disabled", false);
                }
            });
        });

        function applyLeader() {
            // 先“杀光”（降级）所有吧主
            $.ajax({
                url: "/asp/admin/ClubMemberApply.aspx/KillAllLeader",
                type: "POST",
                dataType: "JSON",
                contentType: "application/json; charset=utf-8",
                data: "{ClubId:<%= Request.QueryString["clubid"].ToString() %>}"
            }).done(function (result) {
            }).fail(function () {
                alert("fail to kill all leaders");
            });
            $("input[name='leader']:checked").each(function (i, e) {
                // 一个个添加吧主
                $.ajax({
                    url: "/asp/admin/ClubMemberApply.aspx/ApplyLeader",
                    type: "POST",
                    dataType: "JSON",
                    contentType: "application/json; charset=utf-8",
                    data: "{ClubId:<%= Request.QueryString["clubid"].ToString() %>,UserId:'" + $(this).val() + "'}"
                }).done(function (result) {
                }).fail(function () {
                    alert("fail to add leader");
                });
            });
            alert("分配完毕");
        }
    </script>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" Runat="Server">
    <h3 class="page-header">[<asp:HyperLink ID="ClubUrl" runat="server" Target="_blank" />]所有成员列表</h3>
    <div id="member-list">
        <asp:Repeater ID="Repeater1" runat="server">
            <ItemTemplate>
                <div class="input-group">
                    <span class="input-group-addon">
                        <input type="checkbox" name="leader" value="<%# Eval("UserId") %>" <%# Eval("IsLeader").ToString() == "1" ? "checked='checked'" : "" %> />
                    </span>
                    <input type="text" class="form-control" value="<%# Eval("UserName") %> - <%# Eval("JoinDate") %>" disabled />
                </div>
            </ItemTemplate>
        </asp:Repeater>
        <div class="form-group">
            <button type="button" class="btn btn-primary" style="margin-top: 30px;" onclick="javascrip:applyLeader()">分配</button>
        </div>
    </div>
</asp:Content>

