# frozen_string_literal: true

module Renalware
  describe Renal::Profile do
    it :aggregate_failures do
      is_expected.to belong_to(:patient).touch(true)
      is_expected.to validate_presence_of :patient
      is_expected.to validate_timeliness_of(:esrf_on)
      is_expected.to validate_timeliness_of(:first_seen_on)
      is_expected.to validate_timeliness_of(:comorbidities_updated_on)
      is_expected.to be_versioned
    end
  end
end
