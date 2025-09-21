module Renalware::Patients::Merges
  # Specifies the action to take for a specific schema.table when doing a patient merge
  # (eg HL7 A34). A * in the table_name indicates all tables in the schema that have a
  # patient_id column and are not otherwise specified.
  # Possible values are might be to always merge, merge but warn the user that some interaction
  # may be required, skip this table etc.
  class Rule < ApplicationRecord
    validates :schema_name, :table_name, :merge, presence: true
    validates :table_name, uniqueness: { scope: :schema_name }
  end
end
