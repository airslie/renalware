module Renalware
  module HD
    describe SessionPatientGroupDirectionsQuery do
      subject(:results) { described_class.new(patient:).call(page:, per:) }

      let(:patient) { create(:hd_patient) }
      let(:other_patient) { create(:hd_patient) }
      let(:page) { 1 }
      let(:per) { 2 }

      it "returns the patient's PGDs in reverse session chronology with pagination" do
        oldest_pgd = create(:patient_group_direction, name: "Zulu", code: "Z")
        middle_pgd = create(:patient_group_direction, name: "Beta", code: "B")
        newest_pgd = create(:patient_group_direction, name: "Alpha", code: "A")
        excluded_pgd = create(:patient_group_direction, name: "Other", code: "O")

        create(
          :hd_closed_session,
          patient:,
          started_at: 3.days.ago.change(hour: 9),
          stopped_at: 3.days.ago.change(hour: 13),
          patient_group_directions: [oldest_pgd]
        )
        create(
          :hd_closed_session,
          patient:,
          started_at: 2.days.ago.change(hour: 9),
          stopped_at: 2.days.ago.change(hour: 13),
          patient_group_directions: [middle_pgd]
        )
        create(
          :hd_closed_session,
          patient:,
          started_at: 1.day.ago.change(hour: 9),
          stopped_at: 1.day.ago.change(hour: 13),
          patient_group_directions: [newest_pgd]
        )
        create(
          :hd_closed_session,
          patient: other_patient,
          started_at: Time.zone.now.change(hour: 9),
          stopped_at: Time.zone.now.change(hour: 13),
          patient_group_directions: [excluded_pgd]
        )

        expect(results.map(&:patient_group_direction)).to eq([newest_pgd, middle_pgd])
        expect(results).to all(have_attributes(session: have_attributes(patient:)))
        expect(results.total_pages).to eq(2)
      end
    end
  end
end
