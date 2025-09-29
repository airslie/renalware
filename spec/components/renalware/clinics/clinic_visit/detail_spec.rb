# frozen_string_literal: true

module Renalware
  RSpec.describe Clinics::ClinicVisit::Detail do
    subject { described_class.new(record) }

    let(:location) { build(:clinic_visit_location, :telephone) }
    let(:record) do
      build(
        :clinic_visit,
        location: location,
        notes: "Patient feeling much better today",
        admin_notes: "Remember to schedule follow-up"
      )
    end

    it "renders component" do
      expect(fragment.text).to include("Location:By telephone")
      expect(fragment.text).to include("Notes:Patient feeling much better today")
      expect(fragment.text).to include("Admin notes:Remember to schedule follow-up")
    end
  end
end
