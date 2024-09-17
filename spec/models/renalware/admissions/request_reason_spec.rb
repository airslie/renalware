# frozen_string_literal: true

describe Renalware::Admissions::RequestReason do
  it { is_expected.to validate_presence_of :description }

  it_behaves_like "a Paranoid model"
end
