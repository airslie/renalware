# frozen_string_literal: true

shared_examples_for "Personable" do
  describe "validations" do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:given_name)
      is_expected.to validate_presence_of(:family_name)
    end
  end

  describe "to_s" do
    subject(:user) { described_class.new(given_name: "Aneurin", family_name: "Bevan") }

    it "accepts the :full_name format" do
      expect(user.full_name).to eq("Aneurin Bevan")
    end

    it "accepts the :default format" do
      expect(user.to_s).to match(/^Bevan, Aneurin$/i)
    end
  end
end
