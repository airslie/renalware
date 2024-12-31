module SlimSelectHelper
  # Capybara helper for selecting an option in a slim-select dropdown.
  # Assumption is that you have a label who's parent also contains the select list you
  # are choosing from.
  # Uses a trick to unhide the actual select box, and work with it,
  # instead of the slim_select instance, as that would both:
  # 1. Speed up tests, eliminating waits for animations
  # 2. Increase robustness, as no sleep(x), etc.
  #
  # Usage:
  #   slim_select 'Item name', from: 'Label text
  #
  def slim_select(item_text, options)
    expect(page).to have_field(options[:from], visible: :all)
    select_box = find_field(options[:from], visible: :all)

    if Capybara.current_driver != :rack_test
      page.execute_script(
        "arguments[0].style.display = 'block'",
        select_box
      )
    end

    select item_text, from: options[:from]
  end

  def slim_select_ajax(item_text, options)
    expect(page).to have_field(options[:from], visible: :all)
    select_box = find_field(options[:from], visible: :all)
    data_id = select_box["data-id"]

    # Open the search panel. This creates an element at the bottom of the DOM with
    # the same data-id
    page.find(".ss-main[data-id='#{data_id}'] .ss-placeholder").click
    sleep 1 # TODO: replace with a capybara wait
    page.find("[data-id='#{data_id}'] .ss-search input").set(item_text)
    page.first("[data-id='#{data_id}'] .ss-list .ss-option", visible: true).click
  end
end
