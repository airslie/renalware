# frozen_string_literal: true

describe Renalware::HD::AdministerPrescriptionDropdownComponent, type: :component do
  it "renders the button title" do
    patient = Renalware::Patient.new

    render_inline(described_class.new(patient: patient))

    expect(page).to have_content("Record HD Drugs")
  end

  context "when the patient has no drugs to be given on HD" do
    it "indicates no drugs are available" do
      patient = Renalware::Patient.new

      render_inline(described_class.new(patient: patient))

      expect(page).to have_content("Patient has no drugs to be given on HD")
    end
  end

  context "when the patient has drugs to be given on HD" do
    it "there are dropdown buttons for each drug, linking to the correct location" do
      patient = create(:hd_patient)
      prescriptions = { Drug1: true, Drug2: true, Drug3: false }.map do |drug_name, give_on_hd|
        create(
          :prescription,
          patient: patient,
          administer_on_hd: give_on_hd,
          drug: create(:drug, name: drug_name)
        )
      end

      render_inline(described_class.new(patient: patient))

      expect(page).to have_no_content("Patient has no drugs to be given on HD")

      expect(page).to have_content("Drug1")
      expect(page).to have_content("Drug2")
      expect(page).to have_no_content("Drug3")

      # Note that the links in the html seem to have an .html extension. Not attempting to
      # fix that yet, so specifying an html format here for now
      expect(page).to have_link(href: new_hd_prescription_administration_path(prescriptions[0],
                                                                              format: :html))
      expect(page).to have_link(href: new_hd_prescription_administration_path(prescriptions[1],
                                                                              format: :html))
      expect(page).to have_no_link(href: new_hd_prescription_administration_path(prescriptions[2],
                                                                                 format: :html))
    end
  end
end
