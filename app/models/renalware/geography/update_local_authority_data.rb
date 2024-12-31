# frozen_string_literal: true

module Renalware
  module Geography
    # Given a CSV file that enumerates and defines the relationships between
    # - LADs (Local Authority Districts)
    #  - MSOAs (Middle Super Output Areas)
    #   - LSOAs (Lower Super Output Areas)
    #     - OAs (Output Areas)
    #     - Postcode
    # import the CSV into a working table and then denormalised into relevant geography_* tables.
    #
    # Example download location
    # https://geoportal.statistics.gov.uk/datasets/e7824b1475604212a2325cd373946235/about
    # example filename PCD_OA_LSOA_MSOA_LAD_MAY22_UK_LU.csv
    #
    # Example usage:
    #   UpdateLocalAuthorityData.new(csv_path: path_to_csv).call
    #
    # rubocop:disable Metrics/MethodLength
    class UpdateLocalAuthorityData
      include Callable

      pattr_initialize [:csv_path!]

      def call
        conn = ActiveRecord::Base.connection
        upload_csv_into_working_table(conn)
        denormalize_uploaded_data(conn)
      end

      private

      # Note we can only use Postgres COPY if we stream the CSV content from STDIN (otherwise)
      # the CSV file would have to reside on the same server as the database.
      def upload_csv_into_working_table(conn)
        sql = <<-SQL.squish
          drop table if exists public.tmp_lad_data;
          create table public.tmp_lad_data(
            pcd7 text, pcd8 text, pcds text, dointr text, doterm text,
            usertype text, oa11cd text, lsoa11cd text, msoa11cd text, ladcd text,
            lsoa11nm text, msoa11nm text, ladnm text, ladnmw text
          );

          COPY public.tmp_lad_data (
            pcd7, pcd8, pcds, dointr, doterm, usertype, oa11cd, lsoa11cd,
            msoa11cd, ladcd, lsoa11nm, msoa11nm, ladnm, ladnmw
          ) FROM STDIN
          with (HEADER true, format csv, encoding 'windows-1251');
        SQL

        rc = conn.raw_connection
        rc.exec(sql)

        file = File.open(csv_path, "r")
        rc.put_copy_data(file.readline) until file.eof?
        rc.put_copy_end

        while (res = rc.get_result)
          if (e_message = res.error_message)
            Rails.logger.warn e_message
          end
        end
      end

      def denormalize_uploaded_data(conn)
        sql = <<-SQL.squish
          CREATE INDEX tmp_lad_data_idx ON public.tmp_lad_data USING btree (ladcd, lsoa11cd, msoa11cd);

          insert into renalware.geography_local_authority_districts(code, name)
          select distinct on (ladcd) ladcd, ladnm from public.tmp_lad_data where ladcd != ''
          on conflict do nothing ;
          select * from renalware.geography_local_authority_districts;

          insert into geography_middle_super_output_areas(code, name, local_authority_district_id)
          select distinct on (msoa11cd) msoa11cd, msoa11nm, lad.id from public.tmp_lad_data
          inner join geography_local_authority_districts lad on lad.code = ladcd
          order by msoa11cd
          on conflict do nothing;

          insert into geography_lower_super_output_areas(code, name, middle_super_output_area_id)
          select distinct on (lsoa11cd, lsoa11nm) lsoa11cd, lsoa11nm, msoa.id from public.tmp_lad_data
          inner join geography_middle_super_output_areas msoa on msoa.code = msoa11cd
          order by lsoa11cd, lsoa11nm
          on conflict do nothing ;

          insert into geography_output_areas(code, lower_super_output_area_id)
          select distinct on (oa11cd) oa11cd, lsoa.id from public.tmp_lad_data
          inner join geography_lower_super_output_areas lsoa on lsoa.code = lsoa11cd
          order by oa11cd
          on conflict do nothing ;

          insert into geography_postcodes (postal_code , lower_super_output_area_id)
          select pcds, lsoa.id from public.tmp_lad_data
          inner join geography_lower_super_output_areas lsoa on lsoa.code = lsoa11cd
          on conflict do nothing;
        SQL

        conn.execute(sql)
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
