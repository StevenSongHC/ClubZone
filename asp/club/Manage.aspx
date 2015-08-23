<%@ Page Title="" Language="C#" MasterPageFile="~/asp/Common.master" AutoEventWireup="true" CodeFile="Manage.aspx.cs" Inherits="asp_club_Manage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" Runat="Server">
    <title>管理[<asp:Literal ID="TitleName" runat="server"></asp:Literal>]页面 | 社团空间</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleFile" Runat="Server">
    <link href="/css/club-manage.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptFile" Runat="Server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="Style" Runat="Server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="Script" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            // 只显示3个活动块
            $("#activity-list .item:gt(2)").hide();
            $("#create-activity").click(function (e) {
                // 隐藏该按钮
                $(this).hide();
                // 显示活动发布模版
                $("#activity-template").toggle("slow");
                // 隐藏第三个活动块，因为只显示最多三个块(Block)
                $("#activity-list .item:eq(2)").hide();
            });
        });

        function publishActivity() {
            var actTem = $("#activity-template");
            // 活动内容为空时不操作
            if ($(actTem).find("textarea").val().trim() == "") {
                alert("活动内容不得为空");
                return;
            }
            // 获取活动内容
            var ActivityContent = $(actTem).find("textarea").val().trim();
            // 上传新的活动
            $.ajax({
                url: "/asp/club/Manage.aspx/PublishActivity",
                type: "POST",
                dataType: "JSON",
                contentType: "application/json; charset=utf-8",
                data: "{ClubId:" + <%= Convert.ToInt32(Request.QueryString["id"].ToString()) %> + ",ActivityContent:'" + ActivityContent + "'}"
            }).done(function (result) {
                var json = eval("(" + result.d + ")");
                switch (json.status) {
                    case 1:         // 添加成功，显示新的活动块
                        // 创建新活动的显示块
                        var newAct = "";
                        newAct += "<div class='item col-sm-6 col-md-4' aid='" + json.id + "' style='display: none;'>";
                        newAct += "<div class='thumbnail'>"
                        newAct += "<div class='caption'>"; 
                        newAct += "<h4>" + json.date + "</h4>";
                        newAct += "<p class='content'>" + json.content + "</p>";
                        newAct += "<p class='operation'>";
                        newAct += "<a href='javascript:editActivity(" + json.id + ")' class='show1 btn btn-primary btn-sm' role='button'>编辑</a>";
                        newAct += "<a href='javascript:deleteActivity(" + json.id + ")' class='show1 btn btn-danger btn-sm' role='button' style='margin-left: 4px;'>删除</a>";
                        newAct += "<a href='javascript:submitEditActivity(" + json.id + ")' class='show2 btn btn-success btn-sm' role='button'>发布</a>";
                        newAct += "<a href='javascript:cancelEditActivity(" + json.id + ")' class='show2 btn btn-warning btn-sm' role='button'>取消</a>";
                        newAct += "</p></div></div></div>";
                        // 隐藏活动模版，显示新活动块在发布模板后面
                        $("#activity-template").after(newAct).toggle("fast");
                        $("#activity-list .item:eq(0)").show("slow");
                        // 并删除活动模版内容
                        $("#activity-template").find("textarea").val("");
                        // 显示创建按钮
                        $("#create-activity").show();
                        break;
                    case -1:        // 添加失败
                        alert("添加失败");
                        break;
                    default:        // 未与服务器通信成功
                        alert("未知错误");
                }
            }).fail(function () {
                alert("fail");
            });
        }
        function discard() {
            $("#activity-template").toggle("fast").find("textarea").val("");
            $("#create-activity").show();
            // 重新显示第三块内容
            $("#activity-list .item:eq(2)").show("slow");
        }

        function editActivity(Id) {
            var ele = $("#activity-list>.item[aid='" + Id + "']").find(".content");
            var content = $(ele).html();
            $(ele).html("<textarea rows='3' style='width: 100%;'>" + content + "</textarea>");
            // Hide And Display
            $(ele).parent().find(".show1").hide();
            $(ele).parent().find(".show2").show();
        }
        function submitEditActivity(Id) {
            var ele = $("#activity-list>.item[aid='" + Id + "']").find(".content");
            var Content = $(ele).find("textarea").val().trim();
            if (Content.length < 1) {
                alert("内容不得为空");
            }
            else {
                $.ajax({
                    url: "/asp/club/Manage.aspx/EditActivity",
                    type: "POST",
                    dataType: "JSON",
                    contentType: "application/json; charset=utf-8",
                    data: "{Id:" + Id + ",Content:'" + Content + "'}"
                }).done(function (result) {
                    var json = eval("(" + result.d + ")");
                    switch (json.status) {
                        case 1:         // 修改成功
                            $(ele).html(Content);
                            $(ele).parent().find(".show2").hide();
                            $(ele).parent().find(".show1").show();
                            break;
                        default:
                            alert("未知错误");
                    }
                }).fail(function () {
                    alert("fail");
                });
            }
        }
        function deleteActivity(Id) {
            var ele = $("#activity-list>.item[aid='" + Id + "']").find(".content");
            $.ajax({
                url: "/asp/club/Manage.aspx/DeleteActivity",
                type: "POST",
                dataType: "JSON",
                contentType: "application/json; charset=utf-8",
                data: "{Id:" + Id + "}"
            }).done(function (result) {
                var json = eval("(" + result.d + ")");
                switch (json.status) {
                    case 1:         // 删除成功
                        // 删除活动块
                        $(ele).parent().parent().parent().remove();
                        // 显示后面的
                        $("#activity-list .item:eq(2)").show("slow");
                        break;
                    default:
                        alert("未知错误");
                }
            }).fail(function () {
                alert("fail");
            });
        }
        function cancelEditActivity(Id) {
            var ele = $("#activity-list>.item[aid='" + Id + "']").find(".content");
            var content = $(ele).find("textarea").val();
            $(ele).html(content);
            $(ele).parent().find(".show2").hide();
            $(ele).parent().find(".show1").show();
        }
    </script>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="club-title">
        <div class="photo">
            <asp:Image ID="ClubPhoto" runat="server" CssClass="img-rounded" />
        </div>
        <div class="info">
            <h2><asp:HyperLink ID="ClubUrl" runat="server" /></h2>
            <asp:Literal ID="ClubIntroText" runat="server" />
        </div>
    </div>
    <div style="clear: both;"></div>
    <hr />
    <h3 class="page-header">活动 <span id="create-activity">+</span></h3>
    <div id="activity-list" class="row">
        <div id="activity-template" class="template col-sm-6 col-md-4">
            <div class="thumbnail">
                <div class="caption">
                    <h4>新活动</h4>
                    <p><textarea rows="3" style="width: 100%;" class="form-control" placeholder="输入活动内容"></textarea></p>
                    <p>
                        <a href="javascript:publishActivity()" class="btn btn-success btn-sm" role="button">发布</a>
                        <a href="javascript:discard()" class="btn btn-warning btn-sm" role="button">丢弃</a>
                    </p>
                </div>
            </div>
        </div>
        <asp:Repeater ID="Repeater1" runat="server">
            <ItemTemplate>
                <div class="item col-sm-6 col-md-4" aid="<%# Eval("Id") %>">
                    <div class="thumbnail">
                        <div class="caption">
                            <h4><%# Eval("PublishDate") %></h4>
                            <p class="content"><%# Eval("Content") %></p>
                            <p class="operation">
                                <a href="javascript:editActivity(<%# Eval("Id") %>)" class="show1 btn btn-primary btn-sm" role="button">编辑</a>
                                <a href="javascript:deleteActivity(<%# Eval("Id") %>)" class="show1 btn btn-danger btn-sm" role="button">删除</a>
                                <a href="javascript:submitEditActivity((<%# Eval("Id") %>))" class="show2 btn btn-success btn-sm" role="button">发布</a>
                                <a href="javascript:cancelEditActivity(<%# Eval("Id") %>)" class="show2 btn btn-warning btn-sm" role="button">取消</a>
                            </p>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
    <h3 class="page-header">帖子</h3>
    <table id="article-list" class="table table-hover">
        <thead>
            <tr>
                <th>发布日期</th>
                <th>标题</th>
                <th>作者</th>
                <th>内容预览</th>
                <th>回复数</th>
                <th>操作</th>
            </tr>
        </thead>
        <tbody>
            <asp:Repeater ID="Repeater2" runat="server">
                <ItemTemplate>
                    <tr>
                        <td><%# Eval("PublishDate") %></td>
                        <td><a href="/asp/club/Article.aspx?id=<%# Eval("Id") %>" target="_blank"><%# Eval("Title") %></a></td>
                        <td><%# Eval("PublisherUserName") %></td>
                        <td><%# Eval("Content") %></td>
                        <td><%# Eval("ReplyCount") %></td>
                        <td><a href="/asp/club/DeleteArticle.aspx?id=<%# Eval("Id") %>&clubid=<%= Request.QueryString["Id"] %>&page=<%= Request.QueryString["page"] %>">删除</a></td>
                    </tr>
                </ItemTemplate>
            </asp:Repeater>
        </tbody>
    </table>
    <nav>
        <ul class="pager">
            <li class="previous"><asp:HyperLink ID="PreviousPage" runat="server"><span aria-hidden="true">&larr;</span> 上一页</asp:HyperLink></li>
            <li class="next"><asp:HyperLink ID="NextPage" runat="server">下一页 <span aria-hidden="true">&rarr;</span></asp:HyperLink></li>
        </ul>
    </nav>
</asp:Content>

