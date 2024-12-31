module Renalware
  module Letters
    module Mailshots
      # A list of SQL views with a name starting with "letters_mailshot_"
      # along with some metadata about the view
      class DataSource < ApplicationRecord
        self.table_name = "pg_catalog.pg_views"

        default_scope lambda {
          where(Arel.sql("schemaname like 'renalware%'"))
            .where(Arel.sql("viewname like 'letter_mailshot_%'"))
        }
      end
    end
  end
end
