// On forms with more than one submit button, apply the disable-with label to
// only the clicked button, and just disable the other buttons.
// See for instance the HD Session form.
document.addEventListener("click", function (event) {
  var clicked = event.target.closest(
    ".form-with-multiple-submit-buttons [type=submit]"
  )
  if (!clicked) return

  var form = clicked.closest(".form-with-multiple-submit-buttons")
  form.querySelectorAll("[type=submit]").forEach(function (button) {
    if (button === clicked) return
    button.removeAttribute("data-disable-with")
    button.disabled = true
  })
})

function initClockpickersIn(container) {
  var elem = ".clockpicker"
  var pickerOptions = {
    placement: "right",
    align: "left",
    donetext: "Set",
    autoclose: "true",
  }

  $(container + " " + elem).clockpicker(pickerOptions)

  // Clicking on the clock icon should display the clocpicker
  $(container + " " + elem + "-wrapper .input-group-addon").on(
    "click",
    function () {
      $(this)
        .closest(elem + "-wrapper")
        .find(elem)
        .clockpicker("show")
    }
  )
}

$(function () {
  initClockpickersIn("body")
})
