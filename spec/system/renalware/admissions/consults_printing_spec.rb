module Renalware
  describe "Admission Consult printing" do
    let(:consult_site1) { create(:admissions_consult_site, name: "Site1") }
    let(:consult_site2) { create(:admissions_consult_site, name: "Site2") }
    let(:hospital_unit) { create(:hospital_unit, unit_code: "HospUnit1") }
    let(:hospital_ward) { create(:hospital_ward, name: "Ward1", hospital_unit: hospital_unit) }

    context "when filtered by Active: Yes" do
      it "contains only active consults and the correct filter summary" do
        # Here we force wicked_pdf to render HTML not PDF so we can test the PDF content.
        allow(Renalware.config).to receive(:render_pdf_as_html_for_debugging).and_return(true)
        user = login_as_clinical

        active_consult = create(
          :admissions_consult,
          :active,
          by: user,
          patient: create(:patient, by: user, family_name: "Activia", born_on: "2001-01-01"),
          consult_site: consult_site1,
          hospital_ward: hospital_ward
        )

        inactive_consult = create(
          :admissions_consult,
          :inactive,
          by: user,
          patient: create(:patient, by: user, family_name: "Inactivia", born_on: "1990-01-01"),
          consult_site: consult_site2,
          hospital_ward: hospital_ward
        )

        # Simulate going to Admission Consults, filtering and clicking Print
        visit admissions_consults_path
        select "Yes", from: "Active"
        click_on t("btn.filter")
        click_on "Print (PDF)"

        expect(page.status_code).to eq(200)
        expect(page).to have_content("Admission Consults")
        expect(page).to have_content(l(Time.zone.today))
        expect(page).to have_content("Filters")
        expect(page).to have_content("Active:Yes")

        expect(page).to have_content(active_consult.patient.to_s)
        expect(page).to have_content(l(active_consult.patient.born_on))
        expect(page).to have_content(active_consult.hospital_ward)
        expect(page).to have_content(active_consult.patient.hospital_identifiers)

        expect(page).to have_no_content(inactive_consult.patient.hospital_identifiers)
        expect(page).to have_no_content(inactive_consult.patient.to_s)
      end
    end
  end
end
