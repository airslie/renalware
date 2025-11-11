module Renalware::Patients::Merges
  class Operation < ApplicationRecord
    belongs_to :merge
    has_many :logs, dependent: :destroy

    composed_of :column_reference,
                class_name: "Renalware::ColumnReference",
                mapping: {
                  schema_name: :schema,
                  table_name: :table,
                  column_name: :column
                }

    validates :merge,
              :schema_name,
              :table_name,
              :column_name,
              presence: true
    validates :column_name, uniqueness: { scope: [:merge_id, :schema_name, :table_name] }

    def self.policy_class = Renalware::BasePolicy
  end
end
