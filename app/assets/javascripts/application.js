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
//= require jquery
//= require jquery_ujs
//= require jquery-ui/core
//= require jquery-ui/autocomplete
//= require jquery-ui/sortable
//= require jquery-ui/effect-highlight
//= require foundation
//= require underscore
//= require select2
//= require jquery_nested_form
//= require foundation-datepicker
//= require clockpicker
//= require cocoon
//= require iframeResizer
//= require_tree .

$(document).foundation({
    reveal: {
        animation: 'fadeAndPop',
        animation_speed: 200,
        close_on_background_click: false,
        close_on_esc: true,
        dismiss_modal_class: 'reveal-modal-close'
    }
});
