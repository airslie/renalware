# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  # Don't forget to edit this file to adapt it to your needs (specially
  # all the grid-related classes)
  #
  # Please note that hints are commented out by default since Foundation
  # doesn't provide styles for hints. You will need to provide your own CSS styles for hints.
  # Uncomment them to enable hints.

  config.wrappers :vertical_form,
                  class: :input,
                  hint_class: :field_with_hint,
                  error_class: :error do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label_input
    b.use :error, wrap_with: { tag: :small, class: :error }

    b.use :hint,  wrap_with: { tag: :span, class: :hint }
  end

  config.wrappers :horizontal_tiny,
                  tag: "div",
                  class: "row",
                  hint_class: :field_with_hint,
                  error_class: :error,
                  bla: "h" do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.wrapper :label_wrapper, tag: :div, class: "small-5 medium-4 large-3 columns" do |ba|
      ba.use :label, class: "right inline"
    end

    b.wrapper :right_input_wrapper, tag: :div, class: "small-7 medium-8 large-9 columns" do |ba|
      ba.use :input, class: "tiny-input"
      ba.use :error, wrap_with: { tag: :small, class: %w(error tiny-input) }
      ba.use :hint,  wrap_with: { tag: :span, class: %w(hint tiny-input) }
    end
  end

  config.wrappers :horizontal_small,
                  tag: "div",
                  class: "row",
                  hint_class: :field_with_hint,
                  error_class: :error do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.wrapper :label_wrapper, tag: :div, class: "small-12 medium-4 large-3 columns" do |ba|
      ba.use :label, class: "right inline"
    end

    b.wrapper :right_input_wrapper, tag: :div, class: "small-12 medium-8 large-9 columns" do |ba|
      ba.use :input, class: "small-input"
      ba.use :error, wrap_with: { tag: :small, class: %w(error small-input) }
      ba.use :hint,  wrap_with: { tag: :span, class: %w(mx-5 hint small-input) }
    end
  end

  config.wrappers :bare,
                  tag: "div",
                  class: "row",
                  hint_class: :field_with_hint,
                  error_class: :error do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.wrapper :right_input_wrapper, tag: :div, class: "small-11 columns" do |ba|
      ba.use :input, class: "small-input"
      ba.use :error, wrap_with: { tag: :small, class: %w(error small-input) }
      ba.use :hint,  wrap_with: { tag: :span, class: %w(hint small-input) }
    end
  end

  config.wrappers :zilch,
                  tag: "div",
                  hint_class: :field_with_hint,
                  error_class: :error do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.wrapper :right_input_wrapper, tag: :div, class: "" do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: :small, class: %w(error small-input) }
      ba.use :hint,  wrap_with: { tag: :span, class: %w(hint small-input) }
    end
  end

  config.wrappers :horizontal_medium,
                  tag: "div",
                  class: "row",
                  hint_class: :field_with_hint,
                  error_class: :error do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.wrapper :label_wrapper, tag: :div, class: "small-12 medium-4 large-3 columns" do |ba|
      ba.use :label, class: "right inline"
    end

    b.wrapper :right_input_wrapper,
              tag: :div,
              class: "small-12 medium-8 large-9 columns horizontal_medium" do |ba|
      ba.use :input, class: "medium-input"
      ba.use :error, wrap_with: { tag: :small, class: %w(error medium-input) }
      ba.use :hint,  wrap_with: { tag: :span, class: %w(hint medium-input) }
    end
  end

  config.wrappers :horizontal_large,
                  tag: "div",
                  class: "row",
                  hint_class: :field_with_hint,
                  error_class: :error do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.wrapper :label_wrapper, tag: :div, class: "small-12 medium-4 large-3 columns" do |ba|
      ba.use :label, class: "right inline"
    end

    b.wrapper :right_input_wrapper, tag: :div, class: "small-12 medium-8 large-9 columns" do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: :small, class: ["error"] }
      ba.use :hint,  wrap_with: { tag: :span, class: ["hint"] }
    end
  end

  config.wrappers(:horizontal_form,
                  tag: "div",
                  class: "row",
                  hint_class: :field_with_hint,
                  error_class: :error) do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly

    b.wrapper :label_wrapper, tag: :div, class: "small-3 columns" do |ba|
      ba.use :label, class: "right inline"
    end

    b.wrapper :right_input_wrapper, tag: :div, class: "small-9 columns" do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: :small, class: :error }
      ba.use :hint,  wrap_with: { tag: :span, class: :hint }
    end
  end

  # CSS class for buttons
  config.button_class = "btn btn-primary"

  # Set this to div to make the checkbox and radio properly work
  # otherwise simple_form adds a label tag instead of a div around
  # the nested label
  config.item_wrapper_tag = :div

  # CSS class to add for error notification helper.
  config.error_notification_class = "alert-box alert"

  # The default wrapper to be used by the FormBuilder.
  config.default_wrapper = :vertical_form
end
