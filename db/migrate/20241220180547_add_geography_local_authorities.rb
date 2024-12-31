class AddGeographyLocalAuthorities < ActiveRecord::Migration[7.2]
  # rubocop:disable Rails/CreateTableWithTimestamps
  def change
    within_renalware_schema do
      create_table :geography_local_authority_districts do |t|
        t.string :code, null: false, index: { unique: true }
        t.string :name, null: false, index: { unique: true }
        t.integer :imd_rank, comment: "A simple Index of Multiple Deprivation (IMD) ranking of the LA from most to least deprived."
        t.integer :imd_pct, comment: "Percentage - where the most deprived 1% of LAs are 1 and the next most deprived 1% are 2 etc."
        t.integer :imd_decile, comment: "Grouping the most deprived 10% of LA as Decile 1 and the second most deprived 10% as decile 2 etc."
        t.timestamps default: -> { "CURRENT_TIMESTAMP" }
      end

      comment = <<~COMMENT
        MSOAs are groups of Lower Layer Super Output Areas (LSOAs) -  usually four or five - that
        are used to publish statistics. They are designed to contain between 5,000 and 15,000
        residents and 2,000 and 6,000 households. MSOAs are generated automatically by zone-design
        software using census data. They are often used when statistics cannot be published at the
        LSOA level because they could be disclosive of an individual's data. As of 2021, there were
        6,856 MSOAs in England and 408 in Wales.
      COMMENT
      create_table :geography_middle_super_output_areas, comment: comment do |t|
        t.string :code, null: false, index: { unique: true }
        t.string :name, null: false, index: true
        t.references :local_authority_district,
                     null: false,
                     foreign_key: { to_table: :geography_local_authority_districts }
        t.index %i(code local_authority_district_id), unique: true
        t.timestamps default: -> { "CURRENT_TIMESTAMP" }
      end

      comment = <<~COMMENT
        LSOAs are a type of census geography that were created to allow for comparisons across
        different parts of the country. LSOAs fall within the boundaries of Local Authority
        Districts (LADs). LOSAa comprise between 400 and 1,200 households and have a usually
        resident population between 1,000 and 3,000 persons. LSOAs are made up of groups of
        Output Areas (OAs), usually four or five.
      COMMENT
      create_table :geography_lower_super_output_areas, comment: comment do |t|
        t.string :code, null: false, index: { unique: true }
        t.string :name, null: false
        t.integer :imd_rank, comment: "A simple Index of Multiple Deprivation (IMD) ranking of the LSOA from most to least deprived."
        t.integer :imd_pct, comment: "Percentage - where the most deprived 1% of LSOAs are 1 and the next most deprived 1% are 2 etc."
        t.integer :imd_decile, comment: "Grouping the most deprived 10% of LSOAs as Decile 1 and the second most deprived 10% as decile 2 etc."
        t.references :middle_super_output_area,
                     null: false,
                     foreign_key: { to_table: :geography_middle_super_output_areas }
        t.timestamps default: -> { "CURRENT_TIMESTAMP" }
      end

      comment = <<~COMMENT
        Output Areas (OAs) are the lowest level of geographical area for census statistics and
        were first created following the 2001 Census
      COMMENT
      create_table :geography_output_areas, comment: comment do |t|
        t.string :code, null: false, index: { unique: true }
        t.references :lower_super_output_area,
                     null: false,
                     foreign_key: { to_table: :geography_lower_super_output_areas }
      end

      create_table :geography_postcodes do |t|
        t.string :postal_code, null: false, index: { unique: true }
        t.references :lower_super_output_area,
                     null: false,
                     foreign_key: { to_table: :geography_lower_super_output_areas }
      end
    end
  end
  # rubocop:enable Rails/CreateTableWithTimestamps
end
