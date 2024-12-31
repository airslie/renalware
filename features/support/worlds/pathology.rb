require "array_stringifier"

module World
  module Pathology
    module Domain
      # @section helpers
      #

      # Convert "5 days ago" to a Time object
      def str_to_time(last_observed_at)
        return nil if last_observed_at.nil?

        last_tested_matches =
          last_observed_at.match(/^(?<num>\d+) (?<time_unit>day|days|week|weeks) ago$/)

        if last_tested_matches
          last_tested_matches[:num].to_i.public_send(last_tested_matches[:time_unit]).ago
        end
      end

      # @section commands

      def record_observations(patient:, observations_attributes:)
        patient = Renalware::Pathology.cast_patient(patient)

        observations_attributes.map! { |attrs|
          code = attrs.fetch("code")
          description = Renalware::Pathology::ObservationDescription.find_by(code: code)
          result = attrs.fetch("result")
          observed_at = Time.zone.parse(attrs.fetch("observed_at"))

          { description: description, result: result, observed_at: observed_at }
        }

        Renalware::Pathology::ObservationRequest.create!(
          patient: patient,
          requestor_name: "KCH",
          requested_at: Time.zone.now,
          description: Renalware::Pathology::RequestDescription.first!,
          observations_attributes: observations_attributes
        )
      end

      def create_observation(request:, description_code:, observed_at:)
        description = Renalware::Pathology::ObservationDescription.find_by(code: description_code)

        Renalware::Pathology::Observation.create!(
          request: request,
          description: description,
          observed_at: observed_at,
          result: "100"
        )
      end

      # @section expectations
      #
      def expect_observation_request_to_be_created(attrs)
        observation_request = find_last_observation_request

        expect_attributes_to_match(observation_request, attrs)
      end

      def expect_observations_to_be_created(rows)
        observation_request = find_last_observation_request

        expect(observation_request.observations.count).to eq(rows.size)
        expect_rows_to_match(observation_request.observations, rows)
      end

      def expect_current_observations_to_be(patient:, rows:)
        patient = Renalware::Pathology.cast_patient(patient)
        observation_set = patient.current_observation_set
        rows.each do |row|
          code = row["code"]
          obs_set = observation_set.values[code]

          expect(obs_set[:result]).to eq(row["result"])
          # Some fancy footwork to get dates to compare
          expected_observed_at = l(Time.zone.parse(row["observed_at"]))
          actual_observed_at = l(Time.zone.parse(obs_set[:observed_at]))
          expect(actual_observed_at).to eq(expected_observed_at)
        end
      end

      def expect_rows_to_match(observations, rows)
        rows.each do |attrs|
          description_code = attrs.fetch("description")
          observation = find_observation(observations, description_code)

          expect_attributes_to_match(observation, attrs)
        end
      end

      def expect_attributes_to_match(record, expected_attrs)
        expected_attrs.each do |attr_name, expected_value|
          actual_value = record.public_send(attr_name).to_s
          expect(actual_value).to eq(expected_value)
        end
      end

      def expect_pathology_recent_observations(user:, patient:, rows:)
        create_default_code_group
        expected_rows = rows
        patient = Renalware::Pathology.cast_patient(patient)
        codes = expected_rows.slice(2..-1).map(&:first)
        descriptions = Renalware::Pathology::ObservationDescription.for(codes)

        table = Renalware::Pathology::CreateObservationsGroupedByDateTable.new(
          patient: patient,
          observation_descriptions: descriptions
        ).call

        year_row = table.rows.map(&:observed_on).map(&:year).map(&:to_s).prepend("year")
        expect(expected_rows[0]).to eq(year_row)

        day_row = table.rows.map(&:observed_on).map do |date|
          date.strftime("%d/%m")
        end.prepend("date")
        expect(expected_rows[1]).to eq(day_row)

        expected_rows[2..].each_with_index do |_expected_row, idx|
          # TODO: Complete the test
          # map our table rows into e.g. ["HGB", "", "5.09", "6.09"]
        end
        # expect(view).to match_array(rows)
      end

      def expect_pathology_historical_observations(user:, patient:, rows:)
        create_default_code_group
        expected_rows = rows
        patient = Renalware::Pathology.cast_patient(patient)
        codes = expected_rows.first[1..]
        descriptions = Renalware::Pathology::ObservationDescription.for(codes)

        table = Renalware::Pathology::CreateObservationsGroupedByDateTable.new(
          patient: patient,
          observation_descriptions: descriptions,
          per_page: 10
        ).call

        # Check we got the right codes by mimicking the cucumber title row
        header_row = table.observation_descriptions.map(&:code).prepend("date")
        expect(expected_rows.first).to eq(header_row)

        # Now construct rows to match the cucumber table row and check they match
        expected_rows[1..].each_with_index do |expected_row, idx|
          actual_row = table.rows[idx]
          actual_row_formatted = codes.map { |code| actual_row.row_hash[code]&.first || "" }
          actual_row_formatted.prepend(l(actual_row.observed_on))
          expect(expected_row).to eq(actual_row_formatted)
        end
      end

      def expect_pathology_current_observations(user:, patient:, rows:)
        patient = Renalware::Pathology.cast_patient(patient)
        curr_obs_set = patient.fetch_current_observation_set
        rows.reject! { |row| row[1].blank? } # reject observations with no value
        codes = rows.map(&:first)[1..]

        expect(codes - curr_obs_set.values.keys).to eq([])
      end

      def create_default_code_group
        FactoryBot.create(:pathology_code_group, :default).tap do |cg|
          cg.memberships.create!(
            observation_description:
              Renalware::Pathology::ObservationDescription.find_by(code: "HGB")
          )
          cg.memberships.create!(
            observation_description:
              Renalware::Pathology::ObservationDescription.find_by(code: "MCV")
          )
          cg.memberships.create!(
            observation_description:
              Renalware::Pathology::ObservationDescription.find_by(code: "WBC")
          )
        end
      end

      private

      def find_last_observation_request
        Renalware::Pathology::ObservationRequest.includes(observations: :description).last!
      end

      def find_observation(observations, description_code)
        observations.detect { |obs| obs.description.code == description_code }
      end
    end

    module Web
      include Domain

      # rows - e.g.
      # [
      #   ["year", "2009", "2009", "2009"],
      #   ["date", "13/11", "12/11", "11/11"],
      #   ["HGB", "", "5.09", "6.09"],
      #   ["MCV", "", "3.00", "4.00"],
      #   ["WBC", "2.00", "", ""],
      #   ["AL", "", "", ""]
      # ]
      # TODO: improve this test to examine the actual values not just the counts
      def expect_pathology_recent_observations(user:, patient:, rows:)
        create_default_code_group
        login_as user

        visit patient_pathology_recent_observations_path(patient)
        # first column is a 'th' (the OBX code) so there should one less td
        # than in the array where the first element is a code eg 3 tds in thie example:
        #   ["HGB", "", "5.09", "6.09"]
        expect(page)
          .to have_selector(
            "table#observations tbody tr:first-child td", count: rows.first.size - 1
          )
      end

      def expect_pathology_historical_observations(user:, patient:, rows:)
        create_default_code_group
        login_as user

        visit patient_pathology_historical_observations_path(patient)

        expect(page).to have_selector("table#observations tr", count: rows.size)
      end

      def expect_pathology_current_observations(user:, patient:, rows:)
        # login_as user

        # visit patient_pathology_current_observations_path(patient)

        # puts "FIXME!! - need to reframe this test after changes to current obs"
        # number_of_observation_descriptions =
        #   Renalware::Pathology::RelevantObservationDescription.codes.size
        # expect(page).to have_selector("table.current-observations tbody tr",
        #                               count: number_of_observation_descriptions)
      end
    end
  end
end

Dir[Renalware::Engine.root.join("features/support/worlds/pathology/*.rb")].each { |f| require f }
