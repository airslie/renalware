# frozen_string_literal: true

module Renalware
  module Patients
    describe Bookmark do
      it_behaves_like "a Paranoid model"

      describe "validation" do
        subject { described_class.new(patient: patient, user: user) }

        let(:patient) { build(:patient, by: user) }
        let(:user) { build(:patients_user) }

        it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(%i(patient_id deleted_at)) }
      end

      describe "class methods" do
        subject { described_class }

        it { is_expected.to respond_to(:with_deleted) }
      end
    end
  end
end
