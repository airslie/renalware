# frozen_string_literal: true

describe "Prescriptions - create / edit / terminate", js: true do
  include DrugsSpecHelper

  let(:user) { create(:user, :clinical, additional_roles: :hd_prescriber) }
  let(:patient) { create(:patient, by: user) }
  let(:drug) { create(:drug, name: "Blue Pill") }
  let(:route) { create(:medication_route, name: "Oral") }
  let(:unit_of_measure) { create(:drug_unit_of_measure, name: "Ampoule") }
  let(:form) { create(:drug_form, name: "Capsule") }
  let(:frequency) { create(:drug_frequency, name: "often", title: "Often") }

  before do
    patient
    frequency

    create(
      :drug_vmp_classification,
      unit_of_measure: unit_of_measure,
      route: route,
      form: form,
      drug: drug
    )

    login_as user
    refresh_prescribable_drugs_materialized_view
  end

  it "allows to create, edit and terminate a drug" do
    visit patient_prescriptions_path(
      patient,
      treatable_type: patient.class.to_s,
      treatable_id: patient
    )

    expect(page).to have_content "There are no prescriptions in this list."

    within ".page-actions" do
      click_link "Add"
    end

    #
    # Create a prescription
    expect(page).to have_field "Prescribed on", with: l(Date.current)
    slim_select_ajax "Blue Pill", from: "Drug"
    # ".medications_prescription_drug_id_and_trade_family_id"

    # Should automatically pre-populate as only 1 option available
    # `visible: false` -> due to slim select
    # expect(page).to have_select "Unit of measure", selected: "Ampoule", visible: :hidden
    # expect(page).to have_select "Route", selected: "Oral", visible: :hidden
    # expect(page).to have_select "Form", selected: "Capsule", visible: :hidden
    expect(page).to have_field "Terminated on"
    expect(page).to have_select "Frequency", selected: "Often"

    expect(page).to have_no_field("Stat")
    check("Give on HD")
    expect(page).to have_field("Stat")
    check("Stat")
    uncheck("Give on HD")

    #
    # Test validation
    click_button "Create"
    expect(page).to have_content("Dose amount can't be blank")

    # Now complete all required fields
    fill_in "Dose amount", with: 1
    choose "GP"
    fill_in "Frequency comment", with: "not on Monday"
    click_button "Create"

    # Now on index page
    within "article", text: "Historical" do
      expect(page).to have_content("Blue Pill")
      expect(page).to have_content("1 Ampoule")
      expect(page).to have_content("Often")
      expect(page).to have_content("not on Monday")
      expect(page).to have_content("Oral")
      expect(page).to have_content("GP")
      expect(page).to have_content(l(Date.current))
    end

    within "article", text: "Current" do
      expect(page).to have_content("Blue Pill")
      expect(page).to have_content("1 Ampoule")
      expect(page).to have_content("Often")
      expect(page).to have_content("not on Monday")
      expect(page).to have_content("Oral")
      expect(page).to have_content("GP")
      expect(page).to have_content(l(Date.current))
    end

    #
    # Test Edit
    within "article", text: "Current" do
      click_link "Edit"
    end

    expect(page).to have_field "Dose amount", with: "1"

    expect(page).to have_select "Drug", selected: "Blue Pill", visible: :hidden
    # TODO: check for readonly display of name + hidden id, and add test where dropdowns
    # exists as there are > 1 option
    # expect(page).to have_select "Unit of measure", selected: "Ampoule", visible: :hidden
    # expect(page).to have_select "Route", selected: "Oral", visible: :hidden
    # expect(page).to have_select "Form", selected: "Capsule", visible: :hidden

    expect(page).to have_select "Frequency", selected: "Often"
    expect(page).to have_field "Prescribed on", with: l(Date.current)
    expect(page).to have_field "Terminated on"

    #
    # Change Dose, which would terminate the
    # existing prescription and create a new one with revised values
    fill_in "Dose amount", with: "larger dose"

    click_button "Save"

    expect(page).to have_link "Edit"
    within "article", text: "Current" do
      expect(page).to have_link "Edit"
      # # There will be no Terminate button as it is a stat drug that already has a termination date
      # expect(page).not_to have_link "Terminate"
      expect(page).to have_no_content("Blue Pill Capsule 1 Ampoule")
      expect(page).to have_content("Blue Pill Capsule larger dose Ampoule")
    end

    within "article", text: "Historical" do
      expect(page).to have_content("Blue Pill Capsule 1 Ampoule")
      expect(page).to have_content("Blue Pill Capsule larger dose Ampoule")
    end

    #
    # Terminate the drug in the future, which would still keep
    # it in the current list of drugs
    within "article", text: "Current" do
      click_link "Terminate"
    end

    # Expect the default terminate date to be today
    expect(page).to have_field "Terminated on", with: l(Date.current)

    # Change terminate date to tomorrow
    fill_in "Terminated on", with: l(Date.tomorrow)
    fill_in "Termination notes", with: "Termination Notes"

    click_button "Save"

    # Go and edit the termination date to today
    within "article", text: "Current" do
      expect(page).to have_content "Blue Pill"
      click_link "Edit"
    end

    expect(page).to have_field "Terminated on", with: l(Date.tomorrow)
    fill_in "Terminated on", with: l(Time.zone.today)
    click_button "Save"

    # Now the drug is only in the historial ones

    within "article", text: "Current" do
      expect(page).to have_content "no prescriptions in this list"
    end

    within "article", text: "Historical" do
      expect(page).to have_content "Blue Pill"
      expect(page).to have_no_link "Edit"
    end
  end

  context "with a Trade family" do
    let(:trade_family) { create(:drug_trade_family, name: "TradeFamily") }

    before do
      create(:drug_trade_family_classification,
             trade_family: trade_family,
             drug: drug,
             enabled: true)
      refresh_prescribable_drugs_materialized_view
    end

    it "allows to select a drug with Trade Family" do
      visit new_patient_prescription_path(
        patient,
        treatable_type: patient.class.to_s,
        treatable_id: patient
      )

      slim_select_ajax "Blue Pill (TradeFamily)", from: "Drug"
      sleep 0.5
      # most dropdowns are automatically selected to the first option
      # sleep 1
      # expect(page).to have_select "Unit of measure", selected: "Ampoule", visible: :hidden
      # expect(page).to have_select "Route", selected: "Oral", visible: :hidden
      # expect(page).to have_select "Form", selected: "Capsule", visible: :hidden

      fill_in "Dose amount", with: 1

      click_button "Create"

      within "article", text: "Current" do
        expect(page).to have_content("Blue Pill (TradeFamily)")
        expect(page).to have_content("1 Ampoule")
        expect(page).to have_content("Often")
        expect(page).to have_content("Oral")
        expect(page).to have_content("GP")
        expect(page).to have_content(l(Date.current))
      end

      within "article", text: "Historical" do
        expect(page).to have_content("Blue Pill (TradeFamily) Capsule 1 Ampoule")
      end
    end
  end

  context "with an inactive (disabled) drug for existing prescription" do
    let(:drug) { create(:drug, name: "Blue Pill", inactive: true) }

    before do
      create(
        :prescription,
        treatable: patient,
        patient: patient,
        drug: drug,
        medication_route: route,
        unit_of_measure: unit_of_measure,
        form: form,
        by: user,
        prescribed_on: Date.parse("2022-10-09")
      )
    end

    it "doesn't allow to change the drug, but allows to change other properties", js: false do
      visit patient_prescriptions_path(patient)

      within "article", text: "Current" do
        expect(page).to have_content("Blue Pill")
        expect(page).to have_content("20 Ampoule")
        expect(page).to have_content("daily")
        expect(page).to have_content("Oral")
        expect(page).to have_content("GP")
        expect(page).to have_content("09-Oct-2022")

        click_link "Edit"
      end

      #
      # Edit just the dose
      expect(page).to have_select "Drug", selected: "Blue Pill", disabled: true
      expect(page).to have_content("No longer available")

      expect(page).to have_field "Dose amount", with: "20"
      # expect(page).to have_select "Unit of measure", selected: "Ampoule"
      # expect(page).to have_select "Route", selected: "Oral"
      # expect(page).to have_select "Form", selected: "Capsule"

      expect(page).to have_select "Frequency"
      expect(page).to have_field "Prescribed on", with: "09-Oct-2022"

      #
      # Change dose
      fill_in "Dose amount", with: "larger dose"
      click_button "Save"

      within "article", text: "Current" do
        expect(page).to have_link "Edit"
        expect(page).to have_link "Terminate"
        expect(page).to have_no_content("20 Ampoule")
        expect(page).to have_content("Blue PillCapsulelarger dose Ampoule")
      end

      within "article", text: "Historical" do
        expect(page).to have_content("Blue PillCapsule20 Ampoule")
      end
    end
  end

  context "when choosing 'Other' as frequency" do
    it "allows to specify free text for Frequency", js: true do
      visit new_patient_prescription_path(
        patient,
        treatable_type: patient.class.to_s,
        treatable_id: patient
      )

      slim_select_ajax "Blue Pill", from: "Drug"

      # First entry should be automatically pre-selected
      expect(page).to have_select "Frequency", selected: "Often"

      # Choose "Other" as Frequency instead
      select "Other", from: "Frequency"
      fill_in "Frequency", with: "More Often", match: :prefer_exact

      fill_in "Dose amount", with: 1
      choose "GP"

      click_button "Create"

      #
      # Now on index page
      within "article", text: "Current" do
        expect(page).to have_content("Blue Pill")
        expect(page).to have_content("More Often")
        click_link "Edit"
      end

      expect(page).to have_field "Other frequency", with: "More Often"
      expect(page).to have_select "Frequency", selected: "Other"

      select "Often", from: "Frequency"
      expect(page).to have_no_field "Other frequency", with: "More Often"
    end
  end
end
