# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe "AKI Alert printing" do
    let(:hospital_unit) { create(:hospital_unit, unit_code: "HospUnit1") }
    let(:hospital_ward1) { create(:hospital_ward, name: "Ward1", hospital_unit: hospital_unit) }
    let(:hospital_ward2) { create(:hospital_ward, name: "Ward2", hospital_unit: hospital_unit) }
    let(:aki_action) { create(:aki_alert_action) }

    context "when filtered by Ward: Ward1" do
      it "contains only active consults and the correct filter summary" do
        # Here we force wicked_pdf to render HTML not PDF so we can test the PDF content.
        allow(Renalware.config).to receive(:render_pdf_as_html_for_debugging).and_return(true)

        user = login_as_clinical

        aki_akert_at_ward1 = create(
          :aki_alert,
          notes: "abc",
          patient: create(:renal_patient, family_name: "Patient at Ward1", by: user),
          hotlist: true,
          action: aki_action,
          max_cre: 101,
          cre_date: "2018-01-01",
          hospital_ward: hospital_ward1,
          by: user,
          aki_date: Time.zone.today,
          created_at: Time.zone.today + Time.zone.parse("09:00").seconds_since_midnight.seconds
        )

        aki_akert_at_ward2 = create(
          :aki_alert,
          notes: "xyz",
          patient: create(:renal_patient, family_name: "Patient at Ward2", by: user),
          hotlist: false,
          action: aki_action,
          max_cre: 102,
          cre_date: "2018-01-03",
          hospital_ward: hospital_ward2,
          by: user,
          aki_date: Time.zone.today,
          created_at: Time.zone.today + Time.zone.parse("12:00").seconds_since_midnight.seconds
        )

        # # Simulate going to AKI Alerts, filtering and clicking Print
        visit renal_aki_alerts_path
        # by default the '24 hours before 0945 today' date range filter is selected, so only
        # aki_akert_at_ward1 will be selected as aki_akert_at_ward2 is pas 0945 today

        select "Ward1", from: "Ward"
        click_on t("btn.filter")
        click_on "Print (PDF)"

        expect(page.status_code).to eq(200)
        expect(page).to have_content("AKI Alerts")
        expect(page).to have_content(l(Time.zone.today))
        expect(page).to have_content("Filters")
        expect(page).to have_content("Ward:Ward1")
        expect(page).to have_content(aki_akert_at_ward1.patient.to_s)
        expect(page).to have_content(aki_akert_at_ward1.patient.hospital_identifiers)
        expect(page).to have_content(l(aki_akert_at_ward1.patient.born_on))
        expect(page).to have_content(aki_akert_at_ward1.patient.current_modality)
        expect(page).to have_content(aki_akert_at_ward1.max_cre)
        expect(page).to have_content(l(aki_akert_at_ward1.cre_date))
        expect(page).not_to have_content(aki_akert_at_ward2.patient.to_s)
      end
    end
  end
end
