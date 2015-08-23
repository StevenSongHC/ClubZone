<%@ Page Title="" Language="C#" MasterPageFile="~/asp/Common.master" AutoEventWireup="true" CodeFile="Article.aspx.cs" Inherits="asp_club_Article" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" Runat="Server">
    <title><asp:Literal ID="ArticleTitleText1" runat="server" /> - <asp:Literal ID="ClubNameText" runat="server" /> | 社团空间</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleFile" Runat="Server">
    <link href="/css/article-view.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptFile" Runat="Server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="Style" Runat="Server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="Script" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#new-reply").submit(function (e) {
                if ($(this).find("#articleid").val().length < 1 || $(this).find("#input-reply").val().trim().length < 1) {
                    alert("请写上内容再回复");
                    e.preventDefault();
                    return;
                }
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" Runat="Server">
    <ol class="breadcrumb">
        <li><asp:HyperLink ID="ClubUrl" runat="server" /></li>
        <li class="active"><asp:Literal ID="ArticleTitleText2" runat="server" /></li>
    </ol>
    <div class="jumbotron">
        <h2><asp:Literal ID="ArticleTitleText3" runat="server" /></h2>
        <blockquote>
            <p>
                <asp:Literal ID="ArticleContentText" runat="server" />
            </p>
            <footer>
                <asp:Literal ID="PublisherNameText" runat="server" /> - <asp:Literal ID="PublishDateText" runat="server" />
            </footer>
        </blockquote>
    </div>
    <div id="reply-list">
        <asp:Repeater ID="Repeater1" runat="server">
            <ItemTemplate>
                <div class="item">
                    <blockquote>
                        <p>
                            <%# Eval("Content") %>
                        </p>
                        <footer>
                            <%# Eval("ReplyUserName") %> - <%# Eval("ReplyDate") %>
                        </footer>
                    </blockquote>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
    <% if (User.Identity.IsAuthenticated) { %>
    <h4 class="page-header">回复</h4>
        <form id="new-reply" class="form-horizontal" action="/asp/club/ReplyArticle.aspx">
            <input type="hidden" id="articleid" name="articleid" value="<%= Request.QueryString["id"].ToString() %>" />
            <div class="form-group">
                <div class="col-sm-10">
                    <textarea id="input-reply" name="input-reply" class="form-control" rows="5" placeholder="回复"></textarea>
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-10">
                    <button type="submit" class="btn btn-primary btn-lg">回复</button>
                </div>
            </div>
        </form>
    <% } %>
</asp:Content>

