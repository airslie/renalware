# frozen_string_literal: true

module Renalware
  RSpec.describe Patients::TimelineComponent do
    subject { described_class.new(patient:, current_user:) }

    let(:sort_date) { Date.new(2025, 7, 9) }
    let(:patient) { create(:patient) }
    let(:current_user) { nil }

    before do
      create(:admissions_admission, patient:, admitted_on: sort_date)
    end

    it "renders component" do
      expect(fragment.text).to include("Activity Summary (1)")
      expect(fragment.text).to include("09-Jul-2025AdmissionUnknown")
      expect(fragment.text).to include("Ward A")
    end
  end
end
