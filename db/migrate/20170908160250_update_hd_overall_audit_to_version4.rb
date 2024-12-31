class UpdateHDOverallAuditToVersion4 < ActiveRecord::Migration[5.1]
  def change
    update_view :reporting_hd_overall_audit,
                materialized: true,
                version: 4,
                revert_to_version: 2
  end
end
