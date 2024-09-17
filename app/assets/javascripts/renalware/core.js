// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
// Not that jquery3 is not currently compatible with foundation 5
//= require jquery2
//= require jquery-readyselector
//= require rails-ujs
//= require jquery-ui/core
//= require jquery-ui/widgets/sortable
//= require jquery-ui/effects/effect-highlight
//= require foundation/foundation
//= require foundation/foundation.alert
//= require foundation/foundation.dropdown
//= require foundation/foundation.reveal
//= require foundation/foundation.tab
//= require foundation/foundation.tooltip
//= require foundation/foundation.topbar
//= require underscore/underscore
//= require select2/dist/js/select2
//= require jquery_nested_form
//= require foundation-datepicker/js/foundation-datepicker
//= require cocoon
//= require renalware/iframeResizer
//= require clipboard
//= require masonry-layout/dist/masonry.pkgd
//= require rails.validations
//= require rails.validations.simple_form
//= require print-js/dist/print
//= require moment/moment
//= require trix/dist/trix
//= require_directory ./components
//= require ./built

// Define a console.log if one does not yet exist - e.g. we in IE11
window.console = window.console || { log: function () {} }

$.fn.select2.defaults.set("width", "100%")
