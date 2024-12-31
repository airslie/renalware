module Renalware
  module System
    # Backed by JSONB, stored in view_metadata.filters, a model to allow
    # us to specify how filters for a SQL view are displayed in HTML
    class FilterDefinition
      include StoreModel::Model
      attribute :code, :string
      # The type enum determines how the filter is constructed eg as a list of distinct values
      enum(
        :type,
        {
          list: 0,
          search: 1
        }
      )
      validates :code, presence: true
      validates :type, presence: true

      def title
        code.humanize
        # @title ||= name.presence || code.humanize
      end
    end
  end
end
