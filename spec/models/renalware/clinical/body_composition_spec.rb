require "rails_helper"

module Renalware
  module Clinical
    RSpec.describe BodyComposition, type: :model do
      it { is_expected.to validate_presence_of(:patient) }
      it { is_expected.to validate_presence_of(:assessor) }
      it { is_expected.to validate_presence_of(:total_body_water) }
      it { is_expected.to validate_presence_of(:assessed_on) }
      it { is_expected.to validate_timeliness_of(:assessed_on) }
    end
  end
end