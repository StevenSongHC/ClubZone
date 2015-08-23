<%@ Page Title="" Language="C#" MasterPageFile="~/asp/Common.master" AutoEventWireup="true" CodeFile="EstablishClub.aspx.cs" Inherits="asp_EstablishClub" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Title" Runat="Server">
    <title>建立 [<%= Request.QueryString["club_name"] %>] | 社团空间</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="StyleFile" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ScriptFile" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#club-intro").focus();
        });

        function submit() {
            var ClubName = $("#club-name").val();
            var ClubIntro = $("#club-intro").val();
            if (ClubName.length < 1) {      // 名称为空
                alert("社团名称为空，当前页面将被关闭");
                window.close();
            }
            else {                          // 不为空
                $.ajax({
                    url: "/asp/club/EstablishClub.aspx/SubmitEstablishment",
                    type: "POST",
                    dataType: "JSON",
                    contentType: "application/json; charset=utf-8",
                    data: "{ClubName:'" + ClubName + "',ClubIntro:'" + ClubIntro + "'}"
                }).done(function (result) {
                    var json = eval("(" + result.d + ")");
                    switch (json.status) {
                        case 1:         // 提交成功后，关闭当前页面
                            alert("提交成功，请等待管理员审核");
                            window.close();
                            break;
                        case -1:
                            alert("新建失败，请重试");
                            break;
                        case -2:
                            alert("该社团已存在，又或者已被加入黑名单");
                            break;
                        default:        // 未与服务器通信成功
                            alert("未知错误");
                    }
                }).fail(function () {
                    alert("fail");
                });
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="Style" Runat="Server">
    <style type="text/css">
        #main {
            margin: auto;
            width: 75%;
        }
        .left-container {
            display: inline-block;
            float:left;
            width: 15%;
        }
        .left-container img {
            width: 70%;
            height: 70%;
        }
        .right-container {
            display: inline-block;
            width: 80%;
        }
        #club-name {
            width: 50%;
        }
        #club-intro {
            margin: 20px 0 30px 0;
            width: 75%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="Script" Runat="Server">
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="left-container">
        <img alt="默认图片" title="默认图片" src="/images/club_photo/default.jpg" />
    </div>
    <div class="right-container">
        <div class="input-group">
            <div class="input-group-addon">社团名称</div>
            <input id="club-name" type="text" class="form-control" value="<%= Request.QueryString["club_name"] %>" readonly="true" />
        </div>
        <textarea id="club-intro" class="form-control" rows="3" placeholder="社团简介，推荐填写但不强制"></textarea>
        <button type="button" class="btn btn-info" onclick="javascript:submit()">提交</button>
    </div>
    <div style="clear: both;"></div>
</asp:Content>

