# frozen_string_literal: true

require "csv"

module Renalware
  module Geography
    # Upload Index of Multiple Deprivation (IMD) data.
    # Extract from Consumer Data Research Centre:
    #  The Index of Multiple Deprivation (IMD) datasets are small area measures of relative
    #  deprivation across each of the constituent nations of the United Kingdom. Areas are ranked
    #  from the most deprived area (rank 1) to the least deprived area. Each nation publishes
    #  its data on its own data portal. Each nation measures deprivation in a slightly different
    #  way but the broad themes include income, employment, education, health, crime, barriers to
    #  housing and services, and the living environment.
    #  https://data.cdrc.ac.uk/dataset/index-multiple-deprivation-imd
    #
    # Allow a CSV file defining IMD ranks for LADs and LSOAs to be uploaded and populate the
    # associated columns in tables geography_local_authority_districts and
    # geography_lower_super_output_areas.
    # See also UpdateLocalAuthorityData which must be rune first to populate te regional data.
    # This class just augments the data and does not add any new rows.
    #
    # Download CSV from here, include Scotland and Wales
    # https://data.cdrc.ac.uk/dataset/index-multiple-deprivation-imd#data-and-resources
    #
    # rubocop:disable Metrics/MethodLength
    class UpdateIndexOfMultipleDeprivationData
      include Callable

      pattr_initialize [:csv_path!]

      def call
        Rails.benchmark "UpdateIndexOfMultipleDeprivationData" do
          do_updates
        end
      end

      def do_updates # rubocop:disable Metrics/AbcSize
        lsoa = {}
        lad = {}

        CSV.foreach(csv_path, headers: true) do |row|
          next if row["LSOA"].blank?

          lad_name = row["LANAME"]
          lsoa_code = row["LSOA"]

          lad[lad_name] ||= {
            imd_rank: row["LA_Rank"],
            imd_pct: row["LA_pct"],
            imd_decile: row["LA_decile"]
          }
          lsoa[lsoa_code] = {
            imd_rank: row["Rank"],
            imd_pct: row["SOA_pct"],
            imd_decile: row["SOA_decile"]
          }
        end

        # Some LAs can merge with others etc so expect some to be not found
        lad.each do |name, hash|
          found_lad = LocalAuthorityDistrict.find_by(name: name)
          found_lad.update!(hash) if found_lad && hash
        end

        lsoa.each do |code, hash|
          found_lsoa = LowerSuperOutputArea.find_by(code: code)
          found_lsoa.update!(hash) if found_lsoa && hash
        end
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
