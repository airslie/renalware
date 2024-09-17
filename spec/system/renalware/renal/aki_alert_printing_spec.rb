# frozen_string_literal: true

module Renalware
  describe "AKI Alert printing" do
    let(:hospital_unit) { create(:hospital_unit, unit_code: "HospUnit1") }
    let(:hospital_ward1) { create(:hospital_ward, name: "Ward1", hospital_unit: hospital_unit) }
    let(:hospital_ward2) { create(:hospital_ward, name: "Ward2", hospital_unit: hospital_unit) }
    let(:aki_action) { create(:aki_alert_action) }
    let(:user) { create(:user, :clinical, hospital_centre_id: nil) }

    let(:aki_akert_at_ward1) do
      create(
        :aki_alert,
        notes: "abc",
        patient: create(:renal_patient, given_name: "Peter", family_name: "at Ward1", by: user),
        hotlist: true,
        action: aki_action,
        max_cre: 101,
        cre_date: "2018-01-01",
        hospital_ward: hospital_ward1,
        by: user,
        aki_date: Time.zone.today,
        created_at: Time.zone.today + Time.zone.parse("09:00").seconds_since_midnight.seconds
      )
    end

    let(:aki_akert_at_ward2) do
      create(
        :aki_alert,
        notes: "xyz",
        patient: create(:renal_patient, given_name: "Ben", family_name: "at Ward2", by: user),
        hotlist: false,
        action: aki_action,
        max_cre: 102,
        cre_date: "2018-01-03",
        hospital_ward: hospital_ward2,
        by: user,
        aki_date: Time.zone.today,
        created_at: Time.zone.today + Time.zone.parse("12:00").seconds_since_midnight.seconds
      )
    end

    before do
      aki_akert_at_ward1 && aki_akert_at_ward2

      # Force wicked_pdf to render HTML not PDF so we can test the PDF content.
      allow(Renalware.config).to receive(:render_pdf_as_html_for_debugging).and_return(true)

      login_as user

      visit renal_aki_alerts_path
    end

    it "tests AKI alerts filtering, edit, validation and cancel" do
      # by default the '24 hours before 0945 today' date range filter is selected, so only
      # aki_akert_at_ward1 will be selected as aki_akert_at_ward2 is pas 0945 today
      expect(page).to have_content("AT WARD1, Peter")
      expect(page).to have_no_content("AT WARD2, Ben")

      select "All", from: "Date range"
      click_button "Filter"

      expect(page).to have_content("AT WARD1, Peter")
      expect(page).to have_content("AT WARD2, Ben")

      # test Cancel button after validation error
      within "tr", text: "AT WARD1, Peter" do
        click_link "Edit"
      end

      fill_in "Max AKI", with: 9
      click_button "Save"
      expect(page).to have_content "not included in the list"

      click_link "Cancel"

      # Back at the index page, we should see the previous filter applied
      expect(page).to have_content("AT WARD1, Peter")
      expect(page).to have_content("AT WARD2, Ben")

      within "tr", text: "AT WARD1, Peter" do
        click_link "Edit"
      end

      # Test going back to filters after validation error, then success
      fill_in "Max AKI", with: 9
      click_button "Save"
      expect(page).to have_content "not included in the list"
      fill_in "Max AKI", with: 2
      click_button "Save"

      # Back at the index page, we should see the previous filter applied
      expect(page).to have_content("AT WARD1, Peter")
      expect(page).to have_content("AT WARD2, Ben")

      # check the change was applied
      within "tr", text: "AT WARD1, Peter" do
        expect(page).to have_content("Ward1Yes2") # '2' after 'Yes' is the Max AKI
      end
    end

    context "when filtered by Ward: Ward1" do
      it "prints successfully" do
        select "Ward1", from: "Ward"
        click_button "Filter"

        click_on "Print (PDF)"

        # contains only active consults and the correct filter summary
        expect(page.status_code).to eq(200)
        expect(page).to have_content("AKI Alerts")
        expect(page).to have_content(l(Time.zone.today))
        expect(page).to have_content("Filters")
        expect(page).to have_content("Ward:Ward1")
        expect(page).to have_content(aki_akert_at_ward1.patient.to_s)
        expect(page).to have_content(aki_akert_at_ward1.patient.hospital_identifiers)
        expect(page).to have_content(l(aki_akert_at_ward1.patient.born_on))
        expect(page).to have_content(aki_akert_at_ward1.max_cre)
        expect(page).to have_content(l(aki_akert_at_ward1.cre_date))
        expect(page).to have_no_content(aki_akert_at_ward2.patient.to_s)
      end
    end
  end
end
