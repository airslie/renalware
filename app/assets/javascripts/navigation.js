$(document).ready(function(){

  $(window).scroll(function() {
    var $scroll = $(window).scrollTop();
    if ($scroll > 50){
      $(".remove-name").removeClass("patient-name");
    } else {
      $(".remove-name").addClass("patient-name");
    }
  });


  $("dd").each(function(){
    var $href = $(this).find('a').attr('href');
    if ($href === window.location.pathname) {
      $(this).addClass('active');
    }
  });

  $(document).foundation({
    "magellan-expedition": {
      destination_threshold: 30, //pixels from the top of destination for it to be considered active
      fixed_top: 45, // top distance in pixels assigend to the fixed element on scroll
    }
  });
});