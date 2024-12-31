module Renalware
  module System
    # Backed by Jsonb, stored in view_metadata.columns, a model to allow
    # us to specify how a SQL view column is displayed in an HTML table in the
    # UI.
    class ColumnDefinition
      include StoreModel::Model
      attribute :code, :string
      # An optional title for the column. Code will be used if title is missing
      attribute :name, :string
      attribute :hidden, :boolean, default: false
      # The width enum corresponds to various classes we apply to columns, e.g.
      # if tiny is chosen, then class applied to the th will be col-width-tiny
      enum(
        :width,
        {
          tiny: 0,
          small: 1,
          medium: 2,
          large: 3,
          date: 4,
          datetime: 5,
          nhs_number: 6,
          hospital_numbers: 7,
          patient_name: 8
        }
      )
      # If truncate_with_ellipsis is true we add a class to the td so that it
      # will truncate the text and add .. onm the end
      attribute :truncate, :boolean, default: false

      validates :code, presence: true

      def title
        @title ||= name.presence || code.humanize
      end
    end
  end
end
