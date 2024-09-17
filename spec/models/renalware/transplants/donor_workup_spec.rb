# frozen_string_literal: true

module Renalware
  module Transplants
    describe DonorWorkup do
      it { is_expected.to belong_to(:patient).touch(true) }
      it { is_expected.to be_versioned }
    end
  end
end
