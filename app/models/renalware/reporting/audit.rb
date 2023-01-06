# frozen_string_literal: true

module Renalware
  module Reporting
    class Audit < ApplicationRecord
      validates :name, presence: true
      validates :view_name, presence: true

      scope :enabled, -> { where(enabled: true) }

      def self.available_audit_materialized_views
        result = connection.execute("SELECT oid::regclass::text FROM pg_class
                                     WHERE  relkind in ('m', 'v') and relname like 'reporting_%';")
        result.values.flatten
      end
    end
  end
end
