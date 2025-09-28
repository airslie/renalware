module Renalware::Patients::Merges
  # A log of each row updated during a merge operation
  # The id_of_updated_record is the id of the record in the table referenced by operation.table_name
  # operation.column_name is the FK column (pointing to patients.id) that was changed.
  class Log < ApplicationRecord
    belongs_to :operation

    validates :operation, :id_of_updated_record, presence: true
    validates :id_of_updated_record, uniqueness: { scope: :operation_id }
  end
end
