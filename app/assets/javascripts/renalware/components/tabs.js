function initTabs() {
  $(".sub-nav.with-tabs dl a").on("click", function(e) {
    e.preventDefault();
    var anchor = e.target
    var dl = $(anchor).closest("dl");
    var dd = $(anchor).closest("dd");
    var idToDeactivate = $("dd.active a", dl).attr("href");
    $("dd.active", dl).removeClass("active")
    $(dd).addClass("active");
    var idToActivate = anchor.getAttribute("href");
    $(idToDeactivate).hide();
    $(idToActivate).show();
  })
}

$(function() {
  initTabs();
});
