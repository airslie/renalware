module Renalware
  module HD
    module Sessions
      # Renders an HTML table in a modal dialog. The table is as an aide-memoire to help
      # nurses choose the correct value for washback quality. We display
      # - the grade eg "1"
      # - the name eg "Good"
      # - a description eg "No clotting. Clean filter"
      class WashbackQualityDialogComponent < ApplicationComponent
        attr_reader :html_id

        I18N_KEY = "enumerize.renalware/hd/session_document/dialysis".freeze

        def initialize(html_id: "washback-dialog")
          @html_id = html_id
          super
        end

        # Because we are using enumerize to provide the enumerated options
        # for washback_quality ('name'), washback_quality_description ('description')
        # is stored under another i18n key, so we need to merge the name and description
        # into a hash keyed by eg 1, 2. We can then use this hash to build the HTML
        # table.
        #
        # Example output:
        # {
        #   1 => { name: "Name1", description: "Desc1" },
        #   2 => { name: "Name2", description: "Desc2" },
        #   ..
        # }
        def table_data
          names = I18n.t("washback_quality", scope: I18N_KEY) # could be a string if tn missing
          descriptions = I18n.t("washback_quality_description", scope: I18N_KEY)
          return {} unless names.is_a?(Hash) && descriptions.is_a?(Hash)

          @table_data ||= begin
            names.each_with_object({}) do |name, hash|
              name_key, name_value = name
              hash[name_key] = {
                name: name_value,
                description: descriptions[name_key]
              }
            end
          end
        end
      end
    end
  end
end
