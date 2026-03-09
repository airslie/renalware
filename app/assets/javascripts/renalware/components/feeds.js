document.addEventListener("click", function (event) {
  var link = event.target.closest(".hl7-file-browser a")
  if (!link) return

  console.log(link.dataset.body)

  var field = document.getElementById("feeds_hl7_test_form_body")
  if (field) {
    field.value = link.dataset.body || ""
  }
})
