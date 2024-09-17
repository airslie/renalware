# frozen_string_literal: true

module Renalware
  module Clinics
    class VisitQuery
      attr_reader :visits, :query, :scope

      def initialize(q = {}, scope: ClinicVisit)
        @scope = scope
        @q = q
        @q[:s] = "date DESC" if @q[:s].blank?
      end

      def call
        search.result.includes(
          :created_by,
          :updated_by,
          :clinic,
          :location,
          patient: [current_modality: [:description]]
        )
      end

      def search
        @search ||= scope.extending(RansackScopes).ransack(@q)
      end

      module RansackScopes
        def self.extended(base)
          base.ransacker :starts_at, type: :date do
            Arel.sql("DATE(starts_at)")
          end

          base.ransacker :start_time, type: :datetime do
            Arel.sql("starts_at")
          end
        end
      end
    end
  end
end
