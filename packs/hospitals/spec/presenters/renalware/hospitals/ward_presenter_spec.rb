module Renalware
  describe Hospitals::WardPresenter do
    subject(:presenter) { described_class.new(ward) }

    let(:ward) do
      instance_double(
        Hospitals::Ward,
        name: name,
        code: code,
        hospital_unit: instance_double(Hospitals::Unit, unit_code: "UNITX", name: "Unit X")
      )
    end
    let(:name) { "Ward 1" }
    let(:code) { "W123" }

    describe "#title" do
      subject { presenter.title }

      context "when name and code are present" do
        it { is_expected.to eq("Ward 1 (W123)") }
      end

      context "when code is missing" do
        let(:code) { nil }

        it { is_expected.to eq("Ward 1") }
      end
    end

    describe "#title_including_unit" do
      subject { presenter.title_including_unit }

      it { is_expected.to eq("Ward 1 (W123) at UNITX") }
    end
  end
end
