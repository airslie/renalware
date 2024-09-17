# frozen_string_literal: true

module Renalware
  describe EffectiveUpdatedInfoPresenter do
    let(:subject) { described_class.new(Patient.new) }

    it do
      is_expected.to respond_to :updated_at
      is_expected.to respond_to :created_at
      is_expected.to respond_to :updated_by
    end
  end
end
