require "csv"

module Renalware
  module Feeds
    module Files
      module PracticeMemberships
        class ImportCSV
          pattr_initialize :csv_path

          CSV_HEADER_MAP = {
            gp_code: 0,
            practice_code: 1,
            xxx: 2,
            joined_on: 3,
            left_on: 4,
            unused: 5
          }.freeze

          def call
            batch_import_csv_rows_into_feed_practice_memberships_table
            import_feed_practice_gps_using_sql_function
          end

          private

          # rubocop:disable Lint/AssignmentInCondition, Metrics/AbcSize
          def batch_import_csv_rows_into_feed_practice_memberships_table
            Feeds::PracticeGP.delete_all

            ::File.open(csv_path.realpath.to_s, "r") do |file|
              csv = CSV.new(file, headers: false)
              rows = []
              map = CSV_HEADER_MAP
              while row = csv.shift
                joined_on = row[map[:joined_on]]
                left_on = row[map[:left_on]]

                if joined_on.to_i < 100
                  joined_on = nil
                end

                if left_on.to_i < 100
                  left_on = nil
                end

                rows << Feeds::PracticeGP.new(
                  gp_code: row[map[:gp_code]],
                  practice_code: row[map[:practice_code]],
                  joined_on: joined_on.presence && Date.parse(joined_on),
                  left_on: left_on.presence && Date.parse(left_on)
                )
              end

              # Make about 100 insert queries each with 1000 records
              Feeds::PracticeGP.import!(rows, batch_size: 1000)
            end
          end
          # rubocop:enable Lint/AssignmentInCondition, Metrics/AbcSize

          # See db/functions/import_feed_practice_gps_v02.sql
          # Using a SQL fn here as originally there was quite a bit of SQL involved.
          # Could move this to Ruby.
          def import_feed_practice_gps_using_sql_function
            ActiveRecord::Base.connection.execute("SELECT renalware.import_feed_practice_gps()")
          end
        end
      end
    end
  end
end
