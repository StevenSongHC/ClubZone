<%@ Page Title="" Language="C#" MasterPageFile="~/asp/Common.master" AutoEventWireup="true" CodeFile="ClubList.aspx.cs" Inherits="asp_admin_ClubList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" Runat="Server">
    <title>所有社团管理页面 | 社团空间</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleFile" Runat="Server">
    <link href="/css/club-list.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptFile" Runat="Server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="Style" Runat="Server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="Script" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            // 激活对应选项卡
            var QueryCollection = "<%= Request.QueryString["query_collection"]%>";
            // 默认激活“上线的社团”
            if (QueryCollection == "")
                QueryCollection = "online";
            $("#nav ul>li[query-collection='" + QueryCollection + "']").addClass("active");
        });
    </script>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" Runat="Server">
    <div id="nav">
        <ul class="nav nav-pills nav-stacked">
            <li role="presentation" query-collection="online"><a href="/asp/admin/ClubList.aspx?query_collection=online">上线的社团</a></li>
            <li role="presentation" query-collection="uncensored"><a href="/asp/admin/ClubList.aspx?query_collection=uncensored">未审核</a></li>
            <li role="presentation" query-collection="blacklist"><a href="/asp/admin/ClubList.aspx?query_collection=blacklist">黑名单</a></li>
        </ul>
    </div>
    <div id="list">
        <div id="online">
            <asp:Repeater ID="Repeater1" runat="server">
                <HeaderTemplate>
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>名称</th>
                                <th>图片</th>
                                <th style="width: 30%;">简介</th>
                                <th>建立日期</th>
                                <th>管理吧主</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                            <tr>
                                <th scope="row"><%# Eval("Id") %></th>
                                <td><%# Eval("Name") %></td>
                                <td><img src="<%# Eval("Photo") %>" alt="社团图标" /></td>
                                <td><%# Eval("Intro") %></td>
                                <td><%# Eval("FoundDate") %></td>
                                <td><a href="/asp/admin/ClubMemberApply.aspx?clubid=<%# Eval("Id") %>" target="_blank" title="<%# Eval("Name") %>">点此管理</a></td>
                            </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
        </div>
        <div id="uncensored">
            <asp:Repeater ID="Repeater2" runat="server">
                <HeaderTemplate>
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>名称</th>
                                <th>图片</th>
                                <th style="width: 30%;">简介</th>
                                <th>建立日期</th>
                                <th>开始审核</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                            <tr>
                                <th scope="row"><%# Eval("Id") %></th>
                                <td><%# Eval("Name") %></td>
                                <td><img src="<%# Eval("Photo") %>" alt="社团图标" /></td>
                                <td><%# Eval("Intro") %></td>
                                <td><%# Eval("FoundDate") %></td>
                                <td><a href="/asp/admin/ReviewClub.aspx?id=<%# Eval("Id") %>" target="_blank" title="<%# Eval("Name") %>">点此审核</a></td>
                            </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
        </div>
        <div id="blacklist">
            <asp:Repeater ID="Repeater3" runat="server">
                <HeaderTemplate>
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>名称</th>
                                <th>图片</th>
                                <th style="width: 30%;">简介</th>
                                <th>建立日期</th>
                                <th>重新审核</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                            <tr>
                                <th scope="row"><%# Eval("Id") %></th>
                                <td><%# Eval("Name") %></td>
                                <td><img src="<%# Eval("Photo") %>" alt="社团图标" /></td>
                                <td><%# Eval("Intro") %></td>
                                <td><%# Eval("FoundDate") %></td>
                                <td><a href="/asp/admin/ReviewClub.aspx?id=<%# Eval("Id") %>" target="_blank" title="<%# Eval("Name") %>">点此开始</a></td>
                            </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
        </div>
        <nav>
            <ul class="pager">
                <li class="previous"><asp:HyperLink ID="PreviousPage" runat="server"><span aria-hidden="true">&larr;</span> 上一页</asp:HyperLink></li>
                <li class="next"><asp:HyperLink ID="NextPage" runat="server">下一页 <span aria-hidden="true">&rarr;</span></asp:HyperLink></li>
            </ul>
        </nav>
    </div>
</asp:Content>

