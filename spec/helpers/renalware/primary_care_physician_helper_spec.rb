# frozen_string_literal: true

require "rspec-html-matchers"

module Renalware
  describe PrimaryCarePhysiciansHelper do
    include RSpecHtmlMatchers

    describe "practices_options_for_select" do
      it "returns Practices as html options" do
        p1 = create(:practice, name: "AAA")
        create(:practice, name: "BBB")
        p3 = create(:practice, name: "CCC")
        primary_care_physician = build_stubbed(:primary_care_physician, practices: [p1, p3])
        actual = practices_options_for_select(primary_care_physician)

        expect(actual).to have_tag("option", with: { selected: "selected" }) { with_text("AAA") }
        expect(actual).to have_tag("option") { with_text("BBB") }
        expect(actual).to have_tag("option", with: { selected: "selected" }) { with_text("CCC") }
      end
    end

    describe "practices_or_address" do
      it "formats the alternative Address" do
        address = build_stubbed(:address)
        primary_care_physician = build_stubbed(:primary_care_physician, address: address)
        actual = practices_or_address(primary_care_physician)

        expect(actual.to_s).to match("#{address.street_1}, #{address.postcode}")
      end

      it "formats the practice names when present" do
        practice = create(:practice, name: "Legoland Health Centre")
        primary_care_physician = build_stubbed(:primary_care_physician, practices: [practice])
        actual = practices_or_address(primary_care_physician)

        expect(actual).to match("Legoland Health Centre")
      end
    end
  end
end
