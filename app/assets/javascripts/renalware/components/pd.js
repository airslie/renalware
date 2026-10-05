// Define the global Renalware namespace if not already defined.
var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

// Define the Renalware.PdRegimes closure.
Renalware.PdRegimes = (function () {
  // private functions and vars here
  var duplicateBag = function() {
    $(document).on( "click", "#pd-regime-bags a.duplicate-bag", function(event) {
      event.preventDefault();

      $("a.add-bag").trigger("click");

      var bagToClone = $(this).closest(".fields").first();
      var newBag = $("#pd-regime-bags .fields").last();

      bagToClone.find('select').each(function(i) {
        newBag.find('select').eq(i).val($(this).val());
      });

      var checkedSelector = 'input[type=checkbox],[type=radio]';
      bagToClone.find(checkedSelector).each(function(i) {
        var checked = $(this).is(':checked');
        newBag.find(checkedSelector).eq(i).prop('checked', checked);
      });
    });
  };

  // public functions and vars here
  return {
    init : function() {
      duplicateBag();
    },
    toggleAddRemoveBags : function () {
      $('input.add-bag').hide();
      $('input.remove-bag').hide();
      $('a.add-bag').show();
      $('a.remove-bag').show();
    }
  }
}());
// Bind DOM ready and nested_form:fieldAdded events
// so that buttons are toggled when JS is active.
$(document).ready(Renalware.PdRegimes.init);
$(document).ready(Renalware.PdRegimes.toggleAddRemoveBags);
$(document).on('nested:fieldAdded:bags', Renalware.PdRegimes.toggleAddRemoveBags);
