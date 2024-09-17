# frozen_string_literal: true

describe Renalware::Pathology::Requests::SampleDescription do
  let(:sample_type) { "red cap" }
  let(:sample_number_bottles) { 2 }

  let(:sample_description) do
    described_class.new(sample_type, sample_number_bottles).to_s
  end

  context "when both sample_type and sample_number_bottles are present" do
    it do
      expect(sample_description.to_s)
        .to include(sample_type.to_s, "#{sample_number_bottles} bottles")
    end
  end

  context "when only sample_type is present" do
    let(:sample_number_bottles) { nil }

    it { expect(sample_description.to_s).to include(sample_type.to_s) }
  end

  context "when only sample_number_bottles is present" do
    context "when sample_number_bottles > 1" do
      let(:sample_type) { nil }
      let(:sample_number_bottles) { 3 }

      it { expect(sample_description.to_s).to include("#{sample_number_bottles} bottles") }
    end

    context "when sample_number_bottles = 1" do
      let(:sample_type) { nil }
      let(:sample_number_bottles) { 1 }

      it { expect(sample_description.to_s).to include("#{sample_number_bottles} bottle") }
    end
  end
end
