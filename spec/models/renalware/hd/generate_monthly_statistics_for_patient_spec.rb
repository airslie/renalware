# frozen_string_literal: true

module Renalware
  module HD
    describe GenerateMonthlyStatisticsForPatient do
      include PathologySpecHelper
      subject(:command) { described_class.new(patient: patient, period: period) }

      let(:patient) { create(:hd_patient) }
      let(:period) { MonthPeriod.new(month: 12, year: 2016) }
      let(:hospital_unit) { create(:hospital_unit) }
      let(:month) { 12 }
      let(:year)  { 2016 }
      let(:hgb)   { create(:pathology_observation_description, :hgb) }
      let(:pthi)  { create(:pathology_observation_description, :pthi) }
      let(:phos)  { create(:pathology_observation_description, :phos) }
      let(:cre)   { create(:pathology_observation_description, :cre) }
      let(:ure)   { create(:pathology_observation_description, :ure) }
      let(:urr)   { create(:pathology_observation_description, :urr) }

      it "creates a PatientStatistics for the patient with hd sessions in the specified month " \
         "including a pathology snapshot with a subset of codes" do
        travel_to Date.new(2016, 12, 3) do
          create(:hd_closed_session, patient: patient, hospital_unit: hospital_unit)
          create_observations(
            Renalware::Pathology.cast_patient(patient),
            [hgb, phos, pthi, cre, ure, urr],
            result: 1.0
          )
        end

        expect { command.call }.to change(PatientStatistics, :count).by(1)

        stats = PatientStatistics.first
        expect(stats.patient.id).to eq(patient.id)
        expect(stats.hospital_unit.id).to eq(hospital_unit.id)
        expect(stats.month).to eq(month)
        expect(stats.year).to eq(year)

        # Check the snapshot was stored correctly
        %w(HGB CRE PHOS PTHI URR URE).each do |code|
          expect(stats.pathology_snapshot[code]).to eq(
            "result" => "1.0", "observed_at" => "2016-12-03T00:00:00"
          )
        end
        expect(stats.rolling).to be_nil
        expect(stats.session_count).to eq(1)
      end

      it "update an existing PatientStatistics row if run twice in the for the same month" do
        # We are going to work in Dec 2016
        # Lets add some data:
        travel_to Date.new(2016, 12, 3) do
          create(:hd_closed_session, patient: patient, hospital_unit: hospital_unit)
          create_observations(
            Renalware::Pathology.cast_patient(patient),
            [hgb, phos, pthi, cre, ure, urr],
            result: 1.0
          )
        end

        # Now lets create a PatientStatistics row for Dec 2016 for this patient
        # (one doesn't exist yet)
        expect { command.call }.to change(PatientStatistics, :count).by(1)

        # Now simulate running the job again.
        # We'll pretend we had forgot to add a session on the last day of Dec so we want to
        # re-run it:
        travel_to Date.new(2016, 12, 31) do
          create(:hd_closed_session, patient: patient, hospital_unit: hospital_unit)
        end

        # No new row should be created..
        expect { command.call }.not_to change(PatientStatistics, :count)

        # ..and it should update the stats based on there being another session
        expect(PatientStatistics.first.session_count).to eq(2)
      end

      it "stores a pathology snapshot on the stats row, containing a subset of codes" do
        travel_to Date.new(2016, 12, 3) do
          create(:hd_closed_session, patient: patient, hospital_unit: hospital_unit)
          create_observations(
            Renalware::Pathology.cast_patient(patient),
            [hgb, phos, pthi, cre, ure, urr],
            result: 1.0
          )
        end

        expect { command.call }.to change(PatientStatistics, :count).by(1)

        stats = PatientStatistics.first
        # Check the snapshot was stored correctly
        %w(HGB CRE PHOS PTHI URR URE).each do |code|
          expect(stats.pathology_snapshot[code]).to eq(
            "result" => "1.0", "observed_at" => "2016-12-03T00:00:00"
          )
        end
      end
    end
  end
end
