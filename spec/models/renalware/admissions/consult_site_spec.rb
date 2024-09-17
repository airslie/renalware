# frozen_string_literal: true

describe Renalware::Admissions::ConsultSite do
  it { is_expected.to validate_presence_of(:name) }
end
