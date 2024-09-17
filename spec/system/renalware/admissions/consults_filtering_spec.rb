# frozen_string_literal: true

module Renalware
  describe "Filtering consults" do
    let(:consult_site1) { create(:admissions_consult_site, name: "Site1") }
    let(:consult_site2) { create(:admissions_consult_site, name: "Site2") }
    let(:hospital_unit) { create(:hospital_unit, unit_code: "HospUnit1") }
    let(:hospital_ward) { create(:hospital_ward, name: "Ward1", hospital_unit: hospital_unit) }

    context "when searching by family name and part of given name e.g. Rabbit R" do
      it "succeeds without a 'family_name' is ambiguous' error" do
        create(
          :admissions_consult,
          patient: create(:patient, family_name: "Rabbit", given_name: "Ronald"),
          started_on: Time.zone.today
        )
        login_as_clinical

        visit admissions_consults_path

        within ".filters" do
          fill_in "Hosp/NHS no or name", with: "rabbit r"
          click_on t("btn.filter")
        end

        within ".admissions-consults-table tbody" do
          expect(page).to have_content("RABBIT, Ronald")
        end
      end
    end
  end
end
