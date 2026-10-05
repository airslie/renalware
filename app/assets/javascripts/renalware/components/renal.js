var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.Renal = (function () {

  // If the user wants to overwrite or copy in the patient's current address, clone this
  // from a hidden form and use it to replace the existing visible address form.
  var wireUpUseCurrentAddressButton = function() {
    $("body.renal-profile-edit").on("click",
                                    "#use-current-address-for-address-at-diagnosis",
                                    function(e) {
      e.preventDefault();
      $("#hidden-current-address-form .form-content")
        .clone()
        .replaceAll("#visible-address-form .form-content")
    });
  }

  return {
    init : function() {
      wireUpUseCurrentAddressButton();
    }
  }
}());

$(document).ready(Renalware.Renal.init);
