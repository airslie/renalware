# frozen_string_literal: true

module Renalware
  RSpec.describe Virology::VaccinationDetail do
    subject { described_class.new(record) }

    let(:record) { build(:vaccination) }

    before { create(:vaccination_type) }

    it "renders component" do
      expect(fragment.text).to include("Type:name")
      expect(fragment.text).to include("Drug:The drug")
      expect(fragment.text).to include("Notes:#{record.notes}")
    end
  end
end
