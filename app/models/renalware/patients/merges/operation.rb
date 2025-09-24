module Renalware::Patients::Merges
  class Operation < ApplicationRecord
    belongs_to :merge

    validates :merge,
              :schema_name,
              :table_name,
              :column_name,
              presence: true
    validates :column_name, uniqueness: { scope: [:merge_id, :schema_name, :table_name] }
  end
end
