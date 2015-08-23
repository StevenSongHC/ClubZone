<%@ Page Title="" Language="C#" MasterPageFile="~/asp/Common.master" AutoEventWireup="true" CodeFile="Index.aspx.cs" Inherits="asp_Index" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" Runat="Server">
    <title>欢迎来到社团空间(CluibZone)</title>
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
            // 初始化搜索框
            $("#search-box #type").html("社团");
            $("#navi .index").addClass("focus");
        });
    </script>
</asp:Content>

<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" Runat="Server">
    <!-- 引入搜索框 -->
    <!--#include file="SearchBox.aspx"-->

    <div id="HeadUp" runat="server" class="jumbotron" style="margin-top: 50px;">
        <h2>欢迎加入社团空间</h2>
        <p>
            在这里，你可以创建或者加入任何你感兴趣的社团，与志同道合的人一起交流。
        </p>
        <p>
            鉴于你还没加入任何社团，推荐你按照你所感兴趣的内容搜索社团条目，或者进入导航页发现你所感兴趣的内容。若你所感兴趣的社团未创建，可提交创建申请。
        </p>
        <p>
            <a class="btn btn-primary btn-lg" href="/asp/ClubNavi.aspx" role="button">浏览最新的社团导航</a>
        </p>
    </div>
    <div class="row">
        <div id="club-list" class="col-md-3">
            <asp:Repeater ID="Repeater1" runat="server">
                <ItemTemplate>
                    <div class="panel panel-default">
                        <div class="panel-body">
                            <h4><a href="/asp/club/View.aspx?name=<%# Eval("Name") %>" target="_blank"><%# Eval("Name") %></a></h4>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <div id="article-list" class="col-md-6">
            <asp:Repeater ID="Repeater2" runat="server">
                <ItemTemplate>
                    <div class="panel panel-info">
                        <div class="panel-heading">
                            <h3 class="panel-title"><a href="/asp/club/View.aspx?name=<%# Eval("ClubName") %>" target="_blank"><img src="<%# Eval("ClubPhoto") %>" alt="<%# Eval("ClubName") %>" title="前往<%# Eval("ClubName") %>" /><%# Eval("ClubName") %></a></h3>
                        </div>
                        <div class="panel-body">
                            <a href="/asp/club/Article.aspx?id=<%# Eval("Id") %>" target="_blank"><%# Eval("Title") %></a>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <div id="activity-list" class="col-md-3">
            <asp:Repeater ID="Repeater3" runat="server">
                <ItemTemplate>
                    <blockquote>
                        <p><%# Eval("Content") %></p>
                        <footer><mark title="所在社团"><a href="/asp/club/View.aspx?name=<%# Eval("ClubName") %>" target="_blank"><%# Eval("ClubName") %></a></mark> - <%# Eval("PublishDate") %></footer>
                    </blockquote>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>

