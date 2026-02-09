// App-level defaults for the standalone shell.
if (window.Renalware && Renalware.Configuration) {
  Renalware.Configuration.init({
    disable_inputs_controlled_by_tissue_typing_feed: false,
    disable_inputs_controlled_by_demographics_feed: false
  });
}

// Running integration tests, we turn off animations to reduce the risk of timing errors.
// $.fx.off = true;
