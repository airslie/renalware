module Renalware
  module Patients
    # TODO: if collection is present < 6 items, do not show search field
    class LookupComponent < ApplicationComponent
      def initialize(**opts)
        @form         = opts.fetch(:form)
        @field_id     = opts.fetch(:field_id, :patient_id)
        @collection   = opts.fetch(:collection, [])
        @options_url  = opts.delete(:options_url)
        super
      end

      def call
        form.input(
          field_id,
          collection: collection,
          input_html: { data: data_options },
          include_blank: options_url.blank?
        )
      end

      private

      attr_reader :form,
                  :field_id,
                  :collection,
                  :options_url

      def data_options
        opts = {}
        opts[:options_url] = options_url
        opts[:controller] = options_url.present? ? "slimselect-ajax" : "slimselect"
        opts
      end
    end
  end
end
