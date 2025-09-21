module Renalware::Patients::Merges
  class Operation < ApplicationRecord
    belongs_to :merge

    validates :merge,
              :schema_name,
              :table_name,
              presence: true
    validates :table_name, uniqueness: { scope: [:schema_name, :merge_id] }
  end
end
