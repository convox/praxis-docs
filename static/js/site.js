$( document ).ready(function() {
    $("ol.tabs > li").click(function(e) {
        var i = $(e.target).index();

        $("ol.tabs > li").removeClass("active");
        $("ol.tab-contents > li").removeClass("active");
        $("ol.tabs > li").addClass("inactive");
        $("ol.tab-contents > li").addClass("inactive");

        $("ol.tabs > li").eq(i).addClass("active").removeClass("inactive");
        $("ol.tab-contents > li").eq(i).addClass("active").removeClass("inactive");
    });

    $("ol.tabs > li").eq(0).click();
});

