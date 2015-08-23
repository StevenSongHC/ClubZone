<%@ Page Title="" Language="C#" MasterPageFile="~/asp/Common.master" AutoEventWireup="true" CodeFile="ActivityNavi.aspx.cs" Inherits="asp_ActivityNavi" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" Runat="Server">
    <title>最新的活动导航 | 社团空间</title>
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
            $("#navi .activity").addClass("focus");
        });
    </script>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" Runat="Server">
    <div id="new-activity-list">
        <asp:Repeater ID="Repeater1" runat="server">
            <ItemTemplate>
                <blockquote>
                    <p><%# Eval("Content") %></p>
                    <footer><mark title="所在社团"><a href="/asp/club/View.aspx?name=<%# Eval("ClubName") %>" target="_blank"><%# Eval("ClubName") %></a></mark> - <%# Eval("PublishDate") %></footer>
                </blockquote>
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

