// To initially hide the patient menu on a page, add the class "collapse-patient-menu" to
// the body. However the menu will re-show on browser window resize unless you also add the
// body class "always-collapse-patient-menu".
// Example usage in a slim view e.g MDM show:
//  - content_for(:body_class) { "collapse-patient-menu always-collapse-patient-menu" }
//
$(document).ready(function() {
  $("body").on("click", ".patient-menu-toggler", function(e) {
    $("body").toggleClass("collapse-patient-menu")
             .last().one('transitionend', triggerMasonryLayoutRefresh);
  })

  function triggerMasonryLayoutRefresh() {
    $('.mgrid > .row').masonry('layout');
  }

  function showHidePatientMenuAccordingToScreenSize() {
    if (!$("body").hasClass("always-collapse-patient-menu")) {
      if (isMobileWidth()) {
        $("body").addClass("collapse-patient-menu")
      } else {
        $("body").removeClass("collapse-patient-menu")
      }
    }
    setTimeout(triggerMasonryLayoutRefresh, 300);
  }

  function isMobileWidth() {
    return $('#screen-is-mobile-size').is(':visible');
  }

  $(window).bind("resize", _.debounce(showHidePatientMenuAccordingToScreenSize, 200));
});
