# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Virology
    describe ProfileDocument, type: :model do
      it { is_expected.to respond_to(:hiv) }
      it { is_expected.to respond_to(:hepatitis_b) }
      it { is_expected.to respond_to(:hepatitis_b_core_antibody) }
      it { is_expected.to respond_to(:hepatitis_c) }
      it { is_expected.to respond_to(:htlv) }
    end
  end
end
