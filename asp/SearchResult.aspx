<%@ Page Title="" Language="C#" MasterPageFile="~/asp/Common.master" AutoEventWireup="true" CodeFile="SearchResult.aspx.cs" Inherits="asp_SearchResult" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" Runat="Server">
    <title>搜索 <%= Request.QueryString["type"] %> -> <%= Request.QueryString["keyword"] %> | 社团空间</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleFile" Runat="Server">
    <link href="/css/search-result.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptFile" Runat="Server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="Style" Runat="Server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="Script" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            // init searchbox
            $("#search-box #type").html("<%= Request.QueryString["type"] %>");
            $("#search-box #keyword").val("<%= Request.QueryString["keyword"] %>");

            // hover effect for the items of result list
            $(".result-list .item").hover(function () {
                $(this).animate({borderWidth: "2px"}, "fast");
            }, function () {
                $(this).animate({borderWidth: "0"}, "fast");
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" Runat="Server">
    <!--#include file="SearchBox.aspx"-->
    <div class="page-header">
        <h3>返回的搜索结果：（共<asp:Literal ID="ResultCount" runat="server"></asp:Literal>个结果）<small>该社团没建立？<a class="btn btn-info btn-sm" href="/asp/club/EstablishClub.aspx?club_name=<%= Request.QueryString["keyword"] %>" target="_blank">建立 [<%= Request.QueryString["keyword"] %>]</a></small></h3>
    </div>
    <div class="result-list">
        <asp:Repeater ID="Repeater1" runat="server">
            <ItemTemplate>
                <div class="item">
                    <div class="media">
                        <a class="pull-left" href="/asp/club/View.aspx?name=<%# Eval("Name") %>" target="_blank">
                            <img class="media-object" src="<%# Eval("Photo") %>" alt="<%# Eval("Name") %>" title="前往<%# Eval("Name") %>" />
                        </a>
                        <div class="media-body">
                            <h4><a href="/asp/club/View.aspx?name=<%# Eval("Name") %>" target="_blank"><%# Eval("Name") %></a></h4>
                            <p class="intro">
                                <%# Eval("Intro").ToString() == "" ? "<span class='empty-intro'>暂无简介</span>" : "" %>
                                <%# Eval("Intro") %>
                            </p>
                            <div class="statistics">
                                <span>会员数：<%# Eval("MemberCount") %></span>
                                <span>帖子数：<%# Eval("ArticleCount") %></span>
                                <span>活动数：<%# Eval("ActivityCount") %></span>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
        <asp:Repeater ID="Repeater2" runat="server">
            <ItemTemplate>
                <div class="item">
                    <div class="media">
                        <div class="media-body">
                            <h4><a href="/asp/club/Article.aspx?id=<%# Eval("Id") %>" target="_blank"><%# Eval("Title") %></a> - <small><%# Eval("PublisherUserName") %></small></h4>
                            <p class="intro">
                                <%# Eval("Content") %>
                            </p>
                            <div class="statistics">
                                <span>发布时间：<%# Eval("PublishDate") %></span>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
    <nav>
        <ul class="pager">
            <li><asp:HyperLink ID="PreviousPage" runat="server"><span aria-hidden="true">&larr;</span> 上一页</asp:HyperLink></li>
            <li><asp:HyperLink ID="NextPage" runat="server">下一页 <span aria-hidden="true">&rarr;</span></asp:HyperLink></li>
        </ul>
    </nav>
</asp:Content>

