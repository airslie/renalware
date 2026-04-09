$(document).foundation({
    reveal: {
        animation:  'none' ,
        animation_speed: 0,
        close_on_background_click: true,
        close_on_esc: true,
        dismiss_modal_class: "reveal-modal-close"
    }
});

// Honour any html autofocus attributes on inputs inside a modal dialog
$(document).on('opened.fndtn.reveal', '[data-reveal]', function () {
  var modal = $(this);
  modal.find('[autofocus]').focus();
  // If a modal is launched again, ensure the submit button is re-enabled.
  if ($('input[data-disable-with]').length > 0) {
    Rails.enableElement($('input[data-disable-with]')[0]);
  };
  // Refresh layout of foundation widgets
  $(document).foundation('reflow');
  initClockpickersIn("body");
});

// If there was an error submitting a modal form, be sure to re-enable the submit button
$(document).on('ajax:error', function(event) {
  Rails.enableElement($('input[data-disable-with]')[0]);
});
