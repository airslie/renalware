module Renalware
  module IconHelper
    INLINE_SVG_ICON_SIZE = {
      xs: " h-3 w-3",
      sm: " h-4 w-4",
      md: " h-5 w-5",
      lg: " h-6 w-6",
      xl: " h-7 w-7"
    }.freeze

    # A generic icon helper rendering an inline svg icon file using inline_svg_tag
    # Example usage in a view:
    # = inline_icon(:exclamation)
    # = inline_icon(:exclamation, size: :lg)
    # = inline_icon(:exclamation, class: "fill-red-400 stoke-red-100 inline-block")
    # See `#inline_svg_tag` for acceptable options.
    def inline_icon(name, size: :sm, **options)
      options[:class] ||= ""
      options[:class] ||= " stroke-current fill-current"
      options[:class] += INLINE_SVG_ICON_SIZE.fetch(size.to_sym, "")
      inline_svg_tag("renalware/icons/#{name}.svg", **options)
    end

    # Display a checked icon.
    def inline_checked_icon(**options)
      options[:class] ||= "inline-block fill-green-600"
      inline_icon("check-circle", size: :md, **options) # check-circle is an odd size hence :md
    end

    # Display an unchecked icon
    def inline_unchecked_icon(**options)
      options[:class] ||= "inline-block stroke-gray-400"
      inline_icon("circle", **options)
    end

    # Display a checked icon if boolean value is true, otherwise display an unchecked icon.
    def inline_check_icon(checked, **)
      checked ? inline_checked_icon(**) : inline_unchecked_icon(**)
    end

    def text_with_icon_prefix(text, icon_name, **icon_options)
      tag.div(class: "flex items-center") do
        concat inline_icon(icon_name, **icon_options)
        concat tag.div(class: "ml-2 whitespace-nowrap") { text }
      end
    end
  end
end
