<%@ Page Title="" Language="C#" MasterPageFile="~/asp/Common.master" AutoEventWireup="true" CodeFile="ClubNavi.aspx.cs" Inherits="asp_ClubNavi" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" Runat="Server">
    <title>最新的社团导航 | 社团空间</title>
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
            $("#search-box #type").html("社团");
            $("#navi .club").addClass("focus");
        });
    </script>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" Runat="Server">
    <!--#include file="SearchBox.aspx"-->
    <hr />
    <div id="new-club-list">
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
                <hr />
            </ItemTemplate>
        </asp:Repeater>
    </div>
    <nav>
        <ul class="pager">
            <li class="previous"><asp:HyperLink ID="PreviousPage" runat="server"><span aria-hidden="true">&larr;</span> 上一页</asp:HyperLink></li>
            <li class="next"><asp:HyperLink ID="NextPage" runat="server">下一页 <span aria-hidden="true">&rarr;</span></asp:HyperLink></li>
        </ul>
    </nav>
</asp:Content>

