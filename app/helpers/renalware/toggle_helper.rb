module Renalware
  module ToggleHelper
    def css_toggle_link_to(row_selector:, link_title: "Toggle")
      link_to link_title,
              "#{row_selector} .css-toggle-container",
              class: "button compact low-key",
              data: { behaviour: "css-toggler", turbo: "false" }
    end

    # Non-stimulus implementation for adding a link to toggle open all an adjacent row
    def toggler(row_selector, link_title: "Toggle")
      link_to(
        row_selector,
        data: { behaviour: "toggler", turbo: "false" },
        class: "toggler",
        title: link_title
      ) do
        tag.i
      end
    end

    # Non-stimulus implementation for adding a link to toggle open all togglebale rows in the table
    def table_toggler(link_title: "Toggle all rows")
      link_to(
        "#",
        data: { behaviour: "table-toggler", turbo: "false" },
        class: "toggler",
        title: link_title
      ) do
        tag.i
      end
    end

    def th_toggle_all_rows
      tag.th(class: "noprint togglers") do
        table_toggler(link_title: "Toggle all rows")
      end
    end

    def td_toggle_row(row_selector)
      tag.td(class: "noprint") do
        toggler(row_selector)
      end
    end

    # Create a link in a thead > tr > th that will toggle the last row in all tbodies in the table,
    # where the table contains multiple tbodies and the last row in each is the one that
    # a user can toggle open/closed (to see extended detail for instance).
    # Works in conjunction with the stimulus ToggleController.
    # The enclosing html table must have data-controller="toggle" attribute.
    def rows_toggler(link_title: "Toggle all rows")
      link_to(
        "#",
        data: { action: "toggle#table", turbo: "false" },
        class: "toggler",
        title: link_title
      ) do
        tag.i
      end
    end

    # Create a link to be used in a tbody > tr > td that will toggle the last row in the current
    # tbody, where the table contains multiple tbodies and the last row in each is the one that
    # a user can toggle open/closed (to see extended detail for instance).
    # Works in conjunction with the stimulus ToggleController.
    # The enclosing html table must have data-controller="toggle" attribute.
    def row_toggler(link_title: "Toggle")
      link_to(
        "#",
        data: { action: "click->toggle#row", turbo: "false" },
        class: "toggler",
        title: link_title
      ) do
        tag.i
      end
    end
  end
end
