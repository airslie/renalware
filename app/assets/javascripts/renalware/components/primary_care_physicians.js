var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.PrimaryCarePhysicians = (function () {
  var bindAddressFormToggle = function () {
    $('#address-form-toggle').click(function (e) {
      var button = $(e.target);
      $(button.attr('href')).toggle();
    });
  };

  return {
    // public interface
    init : function () {
      bindAddressFormToggle();
    }
  }
}());

$(document).ready(Renalware.PrimaryCarePhysicians.init);
