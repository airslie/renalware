describe Renalware::Clinics::Clinic do
  it_behaves_like "an Accountable model"
  it_behaves_like "a Paranoid model"

  it { is_expected.to validate_presence_of :name }

  describe "#uniqueness" do
    subject { described_class.new(name: "A", user_id: user.id) }

    let(:user) { create(:user) }

    it { is_expected.to validate_uniqueness_of :code }
  end

  describe "#description" do
    it "appends name and code if both present" do
      expect(described_class.new(name: "A", code: "B").description).to eq("A B")
    end

    it "uses just name if no code present" do
      expect(described_class.new(name: "A", code: "").description).to eq("A")
    end

    it "uses just name if code and name are the same" do
      expect(described_class.new(name: "A", code: "A").description).to eq("A")
    end
  end
end
