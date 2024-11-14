# frozen_string_literal: true

module Renalware
  module System
    # Information on SQL views used to build parts of the UI
    class ViewMetadata < ApplicationRecord
      include RansackAll

      has_paper_trail(
        versions: { class_name: "Renalware::System::Version" },
        on: [:create, :update, :destroy]
      )
      has_many :calls, class_name: "ViewCall", dependent: :destroy

      attribute :columns, ColumnDefinition.to_array_type
      validates :columns, store_model: true

      attribute :filters, FilterDefinition.to_array_type
      validates :filters, store_model: true

      attribute :filters, FilterDefinition.to_array_type
      validates :filters, store_model: true

      # There are two chart columns
      # - chart: for structured chart configuration
      # - chart_raw: to allow any chart json config to be added for greater control
      attribute :chart, ChartDefinition.to_type
      validates :chart, store_model: true

      # This maps to a PG enum
      enum :display_type, { tabular: "tabular" }
      enum :category, { mdm: "mdm", report: "report" }

      scope :refreshable_materialised_views, lambda {
        where(materialized: true).where.not(refresh_schedule: [nil, ""])
      }

      def fully_qualified_view_name
        [schema_name, view_name].compact_blank.join(".")
      end
    end
  end
end
