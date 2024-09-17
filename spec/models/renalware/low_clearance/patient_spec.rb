# frozen_string_literal: true

describe Renalware::LowClearance::Patient do
  it { is_expected.to have_one(:profile) }
end
