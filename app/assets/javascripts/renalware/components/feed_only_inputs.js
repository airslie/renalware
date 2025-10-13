var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.FeedOnlyInputs = (function() {
  // Disable any input/textarea/selects having a data attribute suggesting it is controlled by an
  // external feed. The data in these inouts can be overwritten by the feed at any time so it
  // makes sense not to allow user input.
  // Note that this js file is only re-parsed when it changes, so if you change the value of
  // e.g. disable_inputs_controlled_by_tissue_typing_feed in an initializer, it will not
  // take affect until you clear the assets, or make a change to this file etc.
  var disableFeedOnlyInputs = function() {
    if (Renalware.Configuration.config.disable_inputs_controlled_by_tissue_typing_feed) {
      $("input,textarea,select").filter("[data-controlled-by-tissue-typing-feed]").prop("disabled", true);
    }
  };

  return {
    init: function () {
      disableFeedOnlyInputs();
    }
  };
}());

$(document).ready(Renalware.FeedOnlyInputs.init);
