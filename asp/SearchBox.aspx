<style type="text/css">
    #search-box {
        margin: auto;
    }
    #search-box input {
        width: 350px;
    }
</style>
<script type="text/javascript">
    function search() {
        var Type = $("#search-box #type").html();
        var Keyword = $("#search-box #keyword").val().trim();
        if (Type == "") {
            alert("搜索框未初始化");
            return;
        }
        if (Keyword == "") {
            alert("关键字不得为空");
            return;
        }
        // 返回搜索结果
        if (Type == "社团")
            window.location.href = "/asp/SearchResult.aspx?type=" + Type + "&keyword=" + Keyword;
        else if (Type == "帖子") {
            var clubname = $("#clubname").val();
            // 必须制定社团id
            if (undefined == clubname)
                window.location.href = "/asp/error/IllegalParam.aspx";
            else
                window.location.href = "/asp/SearchResult.aspx?type=" + Type + "&keyword=" + Keyword + "&clubname=" + clubname;
        }
        else {
            window.location.href = "/asp/error/IllegalParam.aspx";
        }
    }
</script>
<div id="search-box" class="input-group">
    <form class="form-inline" action="javascript:search()">
        <input type="hidden" id="clubname" />
        <div class="input-group">
            <div id="type" class="input-group-addon"></div>
            <input id="keyword" type="text" class="form-control" />
            <span class="input-group-btn">
                <button type="button" class="btn btn-primary" onclick="javascript:search()">搜索</button>
            </span>
        </div>
    </form>
</div>