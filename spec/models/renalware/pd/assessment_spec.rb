# frozen_string_literal: true

module Renalware
  module PD
    describe Assessment do
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to respond_to(:document)
        is_expected.to respond_to(:by)
        is_expected.to belong_to(:patient).touch(true)
      end

      describe "Document" do
        subject { Assessment::Document.new }

        it :aggregate_failures do
          is_expected.to respond_to(:had_home_visit)
          is_expected.to validate_timeliness_of(:assessed_on)
          is_expected.to validate_timeliness_of(:home_visit_on)
          is_expected.to validate_timeliness_of(:access_clinic_on)
        end
      end
    end
  end
end
