module Renalware
  module System
    # A list of SQL functions within renalware* schemas, backed by SQL View 'system_sql_functions'.
    # Used in the admin UI to allow a user to choose a function to associate with a NagDefinition
    # for example.
    class SqlFunction < ApplicationRecord
      scope :nag_functions_for_scope, lambda { |scope|
        where("sql_function_name like ?", "#{scope}_nag_%")
      }
    end
  end
end
