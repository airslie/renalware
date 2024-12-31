module Renalware
  module LayoutHelper
    # Partial layout helpers.
    # https://guides.rubyonrails.org/layouts_and_rendering.html#partial-layouts
    # If you don't want the title argument to be used in the browser bar, pass in
    # page_title: in opts also.
    def within_admin_layout(title: nil, **opts)
      within_layout(layout: "renalware/layouts/non_patient",
                    title: opts.fetch(:page_title, title),
                    **opts) { yield }
    end

    def within_patient_layout(args = {}, **)
      within_layout(layout: "renalware/layouts/patient",
                    title: args[:title],
                    **) { yield }
    end

    def within_non_patient_layout
      within_layout(layout: "renalware/layouts/non_patient",
                    title: opts.fetch(:page_title, title),
                    **opts) { yield }
    end

    def within_new_admin_layout(title: nil, **opts)
      within_layout(layout: "renalware/layouts/admin",
                    title: opts.fetch(:page_title, title),
                    **opts) { yield }
    end

    def within_layout(layout:, title: nil, **opts)
      title ||= t?(".page_title") ? t(".page_title") : t(".title", cascade: false)
      opts[:title] = title
      render(layout: layout, locals: opts) { yield }
    end

    def generate_page_title(local_assigns:,
                            patient: nil,
                            separator: Renalware.config.page_title_spearator)
      parts = []
      parts << "#{patient} #{patient.age}y #{patient.sex}" if patient.present?
      parts << Array(local_assigns[:breadcrumbs]).map(&:title)
      parts << local_assigns[:title]
      title = parts.flatten.compact.join(separator)
      content_for(:page_title) { title&.html_safe }
      title
    end

    # Example usage for the edit patient (demographics) page
    # breadcrumbs_and_title(
    #   breadcrumbs: [
    #     Breadcrumb.new(title: "Demographics",
    #                    anchor: link_to("Demographics", patient_path)
    #   ],
    #   title: "Edit"
    # )
    # Returns
    #   Demographics / Edit
    # where Demographics is a link back in the navigation, like a true breadcrumb.
    # :breadcrumbs can be anchors or just a page name, and is single does not need to be an array.
    # :title is normally just a string as it represents the current page, and should not be a link.
    def breadcrumbs_and_title(title:, breadcrumbs: [])
      safe_join(Array(breadcrumbs).map(&:anchor).append(title), " / ")
    end

    # In order for pdf rendering to easily re-use html partials (despite a mime type of :pdf),
    # pass partial rendering code as a block to `with_format`.
    #
    # Example issues and usage trying to render my_partial.html.slim from my_template.pdf.slim:
    #
    #   = render 'my_partial' # cannot resolve the html partial
    #
    #   = render 'my_partial', format: :html # resolves partial but i18n requires an `html:` key
    #
    #   - with_format(:html) do
    #     = render 'my_partial' # resolves the html partial and existing i18n keys are used.
    #
    # See http://stackoverflow.com/questions/339130/how-do-i-render-a-partial-of-a-\
    # different-format-in-rails/3427634#3427634
    def with_format(format)
      old_formats = formats
      begin
        self.formats = [format]
        yield
      ensure
        self.formats = old_formats
      end
    end
  end
end
