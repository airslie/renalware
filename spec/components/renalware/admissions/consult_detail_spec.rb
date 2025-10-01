# frozen_string_literal: true

module Renalware
  RSpec.describe Admissions::ConsultDetail do
    subject { described_class.new(record) }

    let(:record) do
      build(
        :admissions_consult,
        description: "Routine consultation",
        consult_type: "Cardiology review",
        e_alert: true,
        specialty: build(:admissions_specialty, name: "Nephrology"),
        created_by: build(:user, given_name: "John", family_name: "Doe")
      )
    end

    it "renders component with all fields" do
      expect(fragment.text).to include("Author:Doe, John")
      expect(fragment.text).to include("Modality:Not specified")
      expect(fragment.text).to include("Description:Routine consultation")
      expect(fragment.text).to include("E-Alert:Yes")
      expect(fragment.text).to include("Specialty:Nephrology")
      expect(fragment.text).to include("Specialty notes:Cardiology review")
    end
  end
end
