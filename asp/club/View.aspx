<%@ Page Title="" Language="C#" MasterPageFile="~/asp/Common.master" AutoEventWireup="true" CodeFile="View.aspx.cs" Inherits="asp_club_View" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" Runat="Server">
    <title><asp:Literal ID="TitleName" runat="server"></asp:Literal> | 社团空间</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleFile" Runat="Server">
    <link href="/css/club-view.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptFile" Runat="Server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="Style" Runat="Server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="Script" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#search-box #type").html("帖子");
            $("#search-box #keyword").css("width", "475px");
            $("#search-box #clubname").val('<%= Request.QueryString["name"] %>');

            // 控制“退出”按钮样式
            $("#QuitBtn").hover(function () {
                $(this).toggleClass("btn-danger", "on").html("退出");
            }, function () {
                $(this).toggleClass("btn-danger", "off").html("会员");
            });

            // 只显示3条活动记录
            $("#activity-list .item:gt(2)").hide();
            // 隐藏“上一页”
            actPrevBtn = $("#activity-nav .previous");
            actNextBtn = $("#activity-nav .next");
            actPrevBtn.hide();
            // 获得活动总页数
            actCount = $("input[count-page='activity']").val();
            // 若只有一页就也隐藏“下一页”
            if (actCount == 1)
                actNextBtn.hide();

            // 发表帖子前先验证内容是否为空（后台还会再验一次）
            $("#new-article").submit(function (e) {
                if ($(this).find("#clubname").val().length < 1 || $(this).find("#input-title").val().trim().length < 1 || $(this).find("#input-content").val().trim().length < 1) {
                    alert("请发表完整的或合法的帖子，修改后再尝试提交");
                    e.preventDefault();
                    return;
                }
            });
        });

        function getActivityPage(pageIndex) {
            // 显示各按钮与否，并值
            if (pageIndex == 1) {
                actPrevBtn.hide();
                actPrevBtn.attr("href", "javascript:void(0)");
            }
            else {
                actPrevBtn.show();
                actPrevBtn.attr("href", "javascript:getActivityPage(" + (pageIndex - 1) + ")");
            }
            if (pageIndex == actCount) {
                actNextBtn.hide();
                actNextBtn.attr("href", "javascript:void(0)");
            }
            else {
                actNextBtn.show();
                actNextBtn.attr("href", "javascript:getActivityPage(" + (pageIndex + 1) + ")");
            }
            // 为各按钮赋值
            var startIndex = 3 * (pageIndex - 1);    // 起始数据
            // 隐藏所有数据
            $("#activity-list .item").hide("fast");
            // 显示从起始数据开始后的3条
            $("#activity-list .item:eq(" + startIndex + ")").show("fast");
            $("#activity-list .item:eq(" + (startIndex + 1) + ")").show("fast");
            $("#activity-list .item:eq(" + (startIndex + 2) + ")").show("fast");
        }

        function joinClub(IsJoin) {
            $.ajax({
                url: "/asp/club/View.aspx/JoinClub",
                type: "POST",
                dataType: "JSON",
                contentType: "application/json; charset=utf-8",
                data: "{ClubName:'<%= Request.QueryString["name"] %>',IsJoin:" + IsJoin + "}"
            }).done(function () {
                window.location.reload();
            }).fail(function () {
                alert("fail");
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" Runat="Server">
    <!--#include file="/asp/SearchBox.aspx"-->
    <div class="club-title">
        <div class="photo">
            <asp:Image ID="ClubPhoto" runat="server" CssClass="img-rounded" />
        </div>
        <div class="info">
            <h2>
                <asp:Literal ID="ClubNameText" runat="server" />
                &nbsp;&nbsp;&nbsp;&nbsp;
                <asp:HyperLink ID="JoinBtn" ClientIDMode="Static" runat="server" CssClass="btn btn-default btn-sm" NavigateUrl="javascript:joinClub(1)">加入</asp:HyperLink>
                <asp:HyperLink ID="QuitBtn" ClientIDMode="Static" runat="server" CssClass="btn btn-info btn-sm" NavigateUrl="javascript:joinClub(-1)">会员</asp:HyperLink>
            </h2>
            <asp:Literal ID="ClubIntroText" runat="server" />
            <div class="statistics">
                <span class="member-count">会员数：<asp:Literal ID="MemberCount" runat="server" /></span>
                <span class="article-count">发帖数：<asp:Literal ID="ArticleCount" runat="server" /></span>
            </div>
        </div>
    </div>
    <div style="clear: both;"></div>
    <hr />
    <div id="activity-list">
        <input type="hidden" count-page="activity" id="ActivityPageCount" runat="server" />
        <asp:Repeater ID="Repeater1" runat="server">
            <ItemTemplate>
                <div class="item">
                    <blockquote>
                        <p>
                            <%# Eval("Content") %>
                        </p>
                        <footer>
                            <%# Eval("PublishDate") %>
                        </footer>
                    </blockquote>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
    <nav>
        <ul id="activity-nav" class="pager">
            <li><a class="previous" href="javascript:void(0)">&lt;</a></li>
            <li><a class="next" href="javascript:getActivityPage(2)">&gt;</a></li>
        </ul>
    </nav>
    <h3 class="page-header">帖子列表</h3>
    <table id="article-list" class="table table-hover">
        <tbody>
            <asp:Repeater ID="Repeater2" runat="server">
                <ItemTemplate>
                    <tr>
                        <td class="reply-count"><span title="回复量"><%# Eval("ReplyCount") %></span></td>
                        <td class="title"><a href="/asp/club/Article.aspx?id=<%# Eval("Id") %>" target="_blank"><%# Eval("Title") %></a></td>
                        <td class="publisher">-- <%# Eval("PublisherUserName") %></td>
                        <td class="date"><%# Eval("PublishDate") %></td>
                    </tr>
                </ItemTemplate>
            </asp:Repeater>
        </tbody>
    </table>
    <hr />
    <nav>
        <ul class="pager">
            <li class="previous"><asp:HyperLink ID="ArticlePreviousPage" runat="server"><span aria-hidden="true">&larr;</span> 上一页</asp:HyperLink></li>
            <li class="next"><asp:HyperLink ID="ArticleNextPage" runat="server">下一页 <span aria-hidden="true">&rarr;</span></asp:HyperLink></li>
        </ul>
    </nav>
    <h3 class="page-header">发帖</h3>
    <form id="new-article" class="form-horizontal" action="/asp/club/PublishArticle.aspx">
        <input type="hidden" id="clubname" name="clubname" value="<%= Request.QueryString["name"].ToString() %>" />
        <div class="form-group">
            <label for="input-title" class="col-sm-2 control-label">标题</label>
            <div class="col-sm-10">
                <input type="text" class="form-control" id="input-title" name="input-title" placeholder="帖子标题" />
            </div>
        </div>
        <div class="form-group">
            <label for="input-content" class="col-sm-2 control-label">正文</label>
            <div class="col-sm-10">
                <textarea id="input-content" name="input-content" class="form-control" rows="7" placeholder="帖子内容，只有该社团会员才能发帖，不然辛苦码了半天的字没了别怪我"></textarea>
            </div>
        </div>
        <div class="form-group">
            <div class="col-sm-offset-2 col-sm-10">
                <button type="submit" class="btn btn-primary btn-lg">发布</button>
                <button type="reset" class="btn btn-default" style="float: right;">清除</button>
            </div>
        </div>
    </form>
</asp:Content>

