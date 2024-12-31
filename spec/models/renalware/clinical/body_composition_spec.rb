module Renalware
  module Clinical
    describe BodyComposition do
      it_behaves_like "an Accountable model"
      it :aggregate_failures do
        is_expected.to belong_to(:patient).touch(true)
        is_expected.to belong_to(:assessor)
        is_expected.to belong_to(:modality_description)
        is_expected.to validate_presence_of(:patient)
        is_expected.to validate_presence_of(:assessor)
        is_expected.to validate_presence_of(:total_body_water)
        is_expected.to validate_presence_of(:assessed_on)
        is_expected.to validate_timeliness_of(:assessed_on)
        is_expected.to be_versioned
      end
    end
  end
end
