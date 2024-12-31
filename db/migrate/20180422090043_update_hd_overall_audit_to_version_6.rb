class UpdateHDOverallAuditToVersion6 < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      update_view :reporting_hd_overall_audit,
                  materialized: true,
                  version: 6,
                  revert_to_version: 5

      reversible do |direction|
        direction.up do
          connection.execute <<-SQL.squish
            update reporting_audits set display_configuration = '
            {
              "columnDefs": [
                {
                  "title": "Unit",
                  "width": "300",
                  "data": "name"
                },
                {
                  "title": "Year",
                  "width": "100",
                  "data": "year"
                },
                {
                  "title": "Month",
                  "width": "100",
                  "data": "month"
                },
                {
                  "title": "No. patients",
                  "width": "100",
                  "data": "patient_count"
                },
                {
                  "title": "% HGB > 100",
                  "width": "120",
                  "data": "percentage_hgb_gt_100"
                },
                {
                  "title": "% HGB > 130",
                  "width": "120",
                  "data": "percentage_hgb_gt_130"
                },
                {
                  "title": "% Phosphate < 1.8",
                  "width": "120",
                  "data": "percentage_phosphate_lt_1_8"
                },
                {
                  "title": "% PTH < 300",
                  "width": "120",
                  "data": "percentage_pth_lt_300"
                },
                {
                  "title": "% URR > 64",
                  "width": "120",
                  "data": "percentage_urr_gt_64"
                },
                {
                  "title": "% URR > 69",
                  "width": "120",
                  "data": "percentage_urr_gt_69"
                },
                {
                  "title": "% w/fistula or graft",
                  "width": "120",
                  "data": "percentage_access_fistula_or_graft"
                },
                {
                  "title": "Avg. missed HD time",
                  "width": "120",
                  "data": "avg_missed_hd_time"
                },
                {
                  "title": "% sessions >5% dialysis time missed",
                  "width": "200",
                  "data": "pct_missed_sessions_gt_10_pct"
                },
                {
                  "title": "% missing >10% HD sessions",
                  "width": "150",
                  "data": "pct_shortfall_gt_5_pct"
                }
              ]
            }' where view_name ='reporting_hd_overall_audit';
          SQL
        end
      end
    end
  end
end
