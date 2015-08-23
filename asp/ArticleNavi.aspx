<%@ Page Title="" Language="C#" MasterPageFile="~/asp/Common.master" AutoEventWireup="true" CodeFile="ArticleNavi.aspx.cs" Inherits="asp_ArticleNavi" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" Runat="Server">
    <title>最新的帖子导航 | 社团空间</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleFile" Runat="Server">
    <link href="/css/index.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptFile" Runat="Server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="Style" Runat="Server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="Script" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#navi .article").addClass("focus");
        });
    </script>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" Runat="Server">
    <table id="new-article-list" class="table table-hover">
        <tbody>
            <asp:Repeater ID="Repeater1" runat="server">
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
            <li class="previous"><asp:HyperLink ID="PreviousPage" runat="server"><span aria-hidden="true">&larr;</span> 上一页</asp:HyperLink></li>
            <li class="next"><asp:HyperLink ID="NextPage" runat="server">下一页 <span aria-hidden="true">&rarr;</span></asp:HyperLink></li>
        </ul>
    </nav>
</asp:Content>

