function initTogglers() {

  function triggerMasonryLayoutRefresh() {
    $('.mgrid > .row').masonry('layout');
  }

  function toggleTarget(elem, open) {
    // Get e.g. the tr to toggle
    var toggled = $(elem).attr("href");
    $(toggled).toggle(open);
    // If we are toggling open tr B by clicking a link within tr A above it,
    // add a class to the tr A sibling above it so it can also be styled
    // to match the expanded TR B below it, to create a clear connection between the two.
    // $(toggled).prev().toggleClass("content-toggled", open);
    $(elem).closest("tr").toggleClass("content-toggled", open);
  }

  var togglers = $("a[data-behaviour='toggler']");
  if (togglers.length > 0) {
    $(togglers).on("click", function(event) {
      event.preventDefault();
      toggleTarget(event.target);
      triggerMasonryLayoutRefresh();
    })
  }

  // This handles togglers in a thead th that when clicked will open all the
  // toggleable rows in the table.
  var tableTogglers = $("a[data-behaviour='table-toggler']");
  if (tableTogglers.length > 0) {
    $(tableTogglers).on("click", function(event) {
      event.preventDefault();
      var parentTable = $(event.target).closest("table");
      var togglers = $("a[data-behaviour='toggler']", parentTable);

      // If the toggler in the the already has the class togglrf indicting it is
      // toggled open then reverse that anf toggle accordingly
      var open = !$(event.target).hasClass("toggled");
      $(event.target).toggleClass("toggled", open);
      $(togglers).each(function(e) { toggleTarget(this, open) });
      triggerMasonryLayoutRefresh();
    })
  }

  // css-toggler applies where you want a single line of text with a trailing ellipsis
  // contained in a .css-toggle-container to be expandable. Targeting the href selector here
  // will toggle the .expanded class on that element.
  // See the SCSS for what that class does, but it will probably take off the nowrap and allow
  // the content to expand downwards so it is all visible.
  // This is useful for expanding content in a table cell for example.
  var togglers = $("a[data-behaviour='css-toggler']");
  if (togglers.length > 0) {
    $(togglers).on("click", function(event) {
      event.preventDefault();
      var selectorsToToggle = $(event.target).attr("href");
      $(selectorsToToggle).toggleClass("expanded");
      triggerMasonryLayoutRefresh();
    })
  }
}

$(function() {
  initTogglers();
});
