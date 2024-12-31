module Renalware::Letters::Formats::FHIR
  module Resources::TransferOfCare
    describe Sections::PatientDemographicsComponent, type: :component do
      it "displays patient demographic details" do
        patient = build_stubbed(
          :patient,
          family_name: "Pegg",
          given_name: "Jake",
          born_on: "2000-01-01",
          nhs_number: "1234567890",
          email: "rogerrabbit@rmail.co.uk",
          telephone1: "tel123",
          sex: "M"
        )
        address = Renalware::Address.new(
          street_1: "the_street_1",
          street_2: "the_street_2",
          street_3: "the_street_3",
          town: "the_town",
          county: "the_county",
          postcode: "the_postcode"
        )
        allow(patient).to receive(:current_address).and_return(address)
        letter = instance_double(Renalware::Letters::Letter, patient: patient)

        render_inline(described_class.new(letter))

        expect(page).to have_text("Jake")
        expect(page).to have_text("Pegg")
        expect(page).to have_text("01-Jan-2000")
        expect(page).to have_text("1234567890")
        expect(page).to have_text(
          "the_street_1, the_street_2, the_street_3, the_town, the_county, the_postcode"
        )
        expect(page).to have_text("rogerrabbit@rmail.co.uk")
        expect(page).to have_text("tel123")
        expect(page).to have_text("Male")
      end
    end
  end
end
