class ToggleInput < SimpleForm::Inputs::BooleanInput
  def input(_wrapper_options)
    html_options = input_html_options
    html_options[:class] += %w(peer hidden)
    html_options[:hidden] = true

    label_options = label_html_options.merge(
      {
        class: "!inline-flex items-center",
        role: "switch"
      }
    )

    @builder.check_box(attribute_name, html_options) +
      @builder.label(label_target, label_options) do
        toggle + %Q(
          <span class="ml-3">
            <span class="text-sm text-nhs-grey-dark font-medium">#{label_text}</span>
          </span>).html_safe
      end
  end

  def toggle
    '
      <div class="bg-nhs-grey-mid relative inline-flex h-6 w-11 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-nhs-blue-bright focus:ring-offset-2 next-to-checked-down:bg-nhs-blue">
        <span class="translate-x-0 pointer-events-none relative inline-block h-5 w-5 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out next-to-checked-down:translate-x-5">
          <span aria-hidden="true" class="opacity-100 ease-in duration-200 absolute inset-0 flex h-full w-full items-center justify-center transition-opacity next-to-checked-down:opacity-0 next-to-checked-down:ease-out next-to-checked-down:duration-100">
            <svg class="h-3 w-3 text-nhs-grey" fill="none" viewbox="0 0 12 12">
              <path d="M4 8l2-2m0 0l2-2M6 6L4 4m2 2l2 2" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
              </path>
            </svg>
          </span>

          <span aria-hidden="true" class="opacity-0 ease-out duration-100 absolute inset-0 flex h-full w-full items-center justify-center transition-opacity next-to-checked-down:opacity-100 next-to-checked-down:ease-in next-to-checked-down:duration-200">
            <svg class="h-3 w-3 text-nhs-blue" fill="currentColor" viewbox="0 0 12 12">
              <path d="M3.707 5.293a1 1 0 00-1.414 1.414l1.414-1.414zM5 8l-.707.707a1 1 0 001.414 0L5 8zm4.707-3.293a1 1 0 00-1.414-1.414l1.414 1.414zm-7.414 2l2 2 1.414-1.414-2-2-1.414 1.414zm3.414 2l4-4-1.414-1.414-4 4 1.414 1.414z">
              </path>
            </svg>
          </span>
        </span>
      </div>
    '.html_safe
  end
end
