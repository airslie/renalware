SimpleForm.setup do |config|
  def configure_label(b)
    b.wrapper :label_wrapper, tag: :div, class: "wrapper__label" do |ba|
      ba.use :label
    end
  end

  def configure_input(b)
    b.wrapper :right_input_wrapper, tag: :div, class: "wrapper__input" do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: :small, class: ["error"] }
      ba.use :hint,  wrap_with: { tag: :span, class: ["hint"] }
    end
  end

  # Configure various sized wrappers. We use CSS to style the label and inputs within the top div
  # with classes of e.g. "row wrapper-medium"
  %i(xs sm md lg).each do |size|
    config.wrappers(
      :"hz_#{size}", # eg hz_md
      tag: "div",
      class: "row wrapper wrapper_style_horizontal wrapper_size_#{size}",
      hint_class: :field_with_hint,
      error_class: :error
    ) do |b|
      b.use :html5
      b.use :placeholder
      b.optional :maxlength
      b.optional :pattern
      b.optional :min_max
      b.optional :readonly
      configure_label(b)
      configure_input(b)
    end
  end

  # This is a move towards tailwindcss (with layout based on tailwind-ui) for checkboxes.
  # It is not the default wrapper for them but if you have a tailwind form you can specify
  # e.g. in a filter form
  # = f.input :my_bool,
  #           as: :boolean,
  #           wrapper: :tw_bool,
  #           boolean_style: :inline
  # Note because foundation forms have something odd going on with checkbox and label margins
  # (causing the label to appear lower than the input) we manually set the style and margin
  # on the checkbox to override this (using !mb-0 did not work in this case).
  config.wrappers(:tw_bool, tag: :div, class: "relative flex items-start") do |b|
    b.use :html5
    b.wrapper(:y, tag: :div, class: "flex h-5 items-center") do |aa|
      aa.use(
        :input,
        class: "h-4 w-4 !m-0 rounded border-gray-300 text-sky-600 focus:ring-sky-500",
        style: "margin: 0"
      )
    end
    b.wrapper(:y, tag: :div, class: "ml-3 text-sm") do |bb|
      bb.use(:label, class: "font-medium text-gray-700")
      bb.use(:hint, class: "text-gray-500")
    end
  end
end
