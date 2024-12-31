module Renalware
  module Transplants
    describe DonorFollowup do
      it :aggregate_failures do
        is_expected.to belong_to(:operation).touch(true)
        is_expected.to validate_timeliness_of(:last_seen_on)
        is_expected.to validate_timeliness_of(:dead_on)
        is_expected.to be_versioned
      end
    end
  end
end
