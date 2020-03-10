# frozen_string_literal: true

require "rails_helper"

describe "Print a patient's ESA drug list", type: :system, js: true do
  include AjaxHelpers
  let(:esa_drug_type) { create(:drug_type, :esa) }
  let(:immuno_drug_type) { create(:drug_type, :immunosuppressant) }
  let(:esa_drug) do
    create(:drug, name: "esa drug").tap { |drug| drug.drug_types << esa_drug_type }
  end
  let(:immuno_drug) do
    create(:drug, name: "drug2").tap { |drug| drug.drug_types << immuno_drug_type }
  end

  def create_prescription(user, patient, drug, home_delivery: true)
    create(
      :prescription,
      drug: drug,
      by: user,
      dose_amount: "100",
      dose_unit: "milligram",
      patient: patient,
      medication_route: create(:medication_route, :po),
      prescribed_on: "2020-01-01",
      provider: home_delivery ? :home_delivery : :gp
    )
  end

  def create_homecare_form_definintion_for(drug_type, **options)
    create(
      :homecare_form,
      drug_type: drug_type,
      prescription_durations: [3, 6, 9],
      prescription_duration_default: 6,
      prescription_duration_unit: "week",
      form_name: "generic",
      form_version: 1,
      **options
    )
  end

  # context "when no homecare_forms are defined yet" do
  #   it "raises an error" do
  #     user = login_as_clinical
  #     patient = create(:patient, by: user)
  #     dialog = Pages::Medications::HomeDeliveryDialog.new(patient: patient)

  #     expect {
  #       dialog.open
  #     }.to raise_error(
  #       ActiveRecord::RecordInvalid,
  #       "Validation failed: Homecare form can't be blank"
  #     )
  #   end
  # end

  context "when the patient has no ESA home_delivery prescriptions" do
    it "disabled the print button and shows an error" do
      user = login_as_clinical
      patient = create(:patient, by: user)
      create_prescription(user, patient, esa_drug, home_delivery: false)
      create_homecare_form_definintion_for(esa_drug_type)

      dialog = Pages::Medications::HomeDeliveryDialog.new(patient: patient)
      dialog.open

      expect(dialog.drug_type).to eq("ESA") # first, so will be selected
      expect(dialog.prescription_duration).to eq("6 weeks") # duration option should be selected
      expect(dialog).not_to have_enabled_print_button
      expect(dialog).to have_no_prescriptions_error
    end
  end

  context "when the patient has immunossupressant home_delivery prescriptions" do
    it "allows the user to print them" do
      user = login_as_clinical
      patient = create(:patient, by: user)
      prescription = create_prescription(user, patient, immuno_drug, home_delivery: true)
      create_homecare_form_definintion_for(
        esa_drug_type,
        prescription_duration_default: 6
      )
      immuno_homecare_form_definition = create_homecare_form_definintion_for(
        immuno_drug_type,
        prescription_duration_default: 9
      )

      dialog = Pages::Medications::HomeDeliveryDialog.new(patient: patient)
      dialog.open

      expect(dialog.drug_type).to eq("ESA") # first, so will be selected
      expect(dialog.prescription_duration).to eq("6 weeks") # esa default

      # selecting immunosuppressant should update the prescription duration
      # options and select the default one for that drug type
      select "Immunosuppressant", from: "Drug type"
      wait_for_ajax
      expect(dialog.prescription_duration).to eq("9 weeks") # immuno default

      # Click on Print
      expect(dialog).to have_enabled_print_button
      dialog.print

      # We have opened a PDF in a new tab but stayed on this one in the current tab
      wait_for_ajax

      expect(page).to have_content("Was printing successful?")

      dialog.indicate_printing_was_succesful
      wait_for_ajax
      expect(dialog).not_to be_visible

      # Should have updated delivery dates
      expect(prescription.reload).to have_attributes(
        last_delivery_date: Time.zone.today,
        next_delivery_date: Time.zone.today + 9.weeks
      )

      # event should be marked as printed
      event = Renalware::Medications::Delivery::Event.last
      expect(event).to have_attributes(
        printed: true,
        drug_type: immuno_drug_type,
        prescription_duration: 9,
        created_by: user,
        homecare_form: immuno_homecare_form_definition
      )
    end
  end
end