# frozen_string_literal: true

require "core_extensions/i18n/handle_blank_value"

module CoreExtensions
  describe I18n::HandleBlankValue, type: :lib do
    before do
      ::I18n.extend described_class
    end

    describe ".localize" do
      it "returns empty string if provided a nil value" do
        expect(::I18n.l(nil)).to eq("")
      end

      it "returns empty string if provided an empty string" do
        expect(::I18n.l("")).to eq("")
      end

      it "returns something when not blank" do
        expect(::I18n.l(Time.zone.now)).not_to be_blank
      end
    end

    describe ".l" do
      it "is the same as .localize" do
        expect(::I18n.method(:l)).to eq(::I18n.method(:localize))
      end
    end
  end
end
