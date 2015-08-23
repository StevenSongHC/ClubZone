<%@ Page Title="" Language="C#" MasterPageFile="~/asp/Common.master" AutoEventWireup="true" CodeFile="PersonalHomePage.aspx.cs" Inherits="asp_PersonalHomePage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" Runat="Server">
    <title>我的主页 | 社团空间</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="StyleFile" Runat="Server">
    <link href="/css/personal-homepage.css" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptFile" Runat="Server">
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="Style" Runat="Server">
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="Script" Runat="Server">
</asp:Content>

<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="page-header">
        <h3>我的社团</h3>
    </div>
    <div id="club-list">
        <ul id="leader" class="list-group">
            <asp:Repeater ID="Repeater1" runat="server">
                <ItemTemplate>
                    <li class="list-group-item list-group-item-info">
                        <a href="/asp/club/Manage.aspx?id=<%# Eval("Id") %>" target="_blank">
                            <h4><%# Eval("Name") %>（进入管理）</h4>
                            <p>
                                <span class="statistics">会员数：<%# Eval("MemberCount") %></span>
                                <span class="statistics">帖子数：<%# Eval("ArticleCount") %></span>
                                <span class="statistics">活动数：<%# Eval("ActivityCount") %></span>
                            </p>
                        </a>
                    </li>
                </ItemTemplate>
            </asp:Repeater>
        </ul>
        <ul id="member" class="list-group">
            <asp:Repeater ID="Repeater2" runat="server">
                <ItemTemplate>
                    <li class="list-group-item">
                        <a href="/asp/club/View.aspx?name=<%# Eval("Name") %>" target="_blank"><%# Eval("Name") %></a>
                    </li>
                </ItemTemplate>
            </asp:Repeater>
        </ul>
    </div>
    <div class="page-header">
        <h3>最近帖子（显示至多3条）</h3>
    </div>
    <div id="article-list">
        <asp:Repeater ID="Repeater3" runat="server">
            <ItemTemplate>
                <div class="item">
                    <div class="media">
                        <div class="pull-left">
                            <a href="/asp/club/View.aspx?Name=<%# Eval("ClubName") %>" target="_blank">
                                <img class="media-object" src="<%# Eval("ClubPhoto") %>" alt="<%# Eval("ClubName") %>" />
                            </a>
                        </div>
                        <div class="media-body">
                            <h4 class="media-heading"><a href="/asp/club/Article.aspx?id=<%# Eval("Id") %>" target="_blank">《<%# Eval("Title") %>》&nbsp;&nbsp;&nbsp;发表在 - <%# Eval("ClubName") %><small> -- <%# Eval("PublishDate") %></small></a></h4>
                            <p>
                                <%# Eval("Content") %>
                            </p>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
    <div class="page-header">
        <h3>最近回复（显示至多3条）</h3>
    </div>
    <div id="reply-list">
        <asp:Repeater ID="Repeater4" runat="server">
            <ItemTemplate>
                <div class="item">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h3 class="panel-title"><a href="/asp/club/Article.aspx?id=<%# Eval("ArticleId") %>" target="_blank">回复： [<%# Eval("ArticleTitle") %>]<small> -- <%# Eval("ReplyDate") %> </small></a></h3>
                        </div>
                        <div class="panel-body">
                             <%# Eval("Content") %>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>

