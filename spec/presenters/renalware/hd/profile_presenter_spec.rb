describe Renalware::HD::ProfilePresenter do
  describe "#formatted_anuric" do
    it "returns Unknown when anuric is not set" do
      profile = build(:hd_profile, anuric: nil)

      expect(described_class.new(profile).formatted_anuric).to eq("Unknown")
    end

    it "returns Yes when anuric is true" do
      profile = build(:hd_profile, anuric: true)

      expect(described_class.new(profile).formatted_anuric).to eq("Yes")
    end

    it "returns No when anuric is false" do
      profile = build(:hd_profile, anuric: false)

      expect(described_class.new(profile).formatted_anuric).to eq("No")
    end
  end
end
