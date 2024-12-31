module Renalware
  module Reporting
    class FetchAuditJson
      class << self
        def call(view_name)
          convert_rows_from_audit_view_into_datatables_compatible_json(view_name)
        end

        def convert_rows_from_audit_view_into_datatables_compatible_json(view_name)
          conn = ActiveRecord::Base.connection
          result = conn.execute("select audit_view_as_json(#{conn.quote(view_name)});")
          result.values[0][0]
        end
      end
    end
  end
end
