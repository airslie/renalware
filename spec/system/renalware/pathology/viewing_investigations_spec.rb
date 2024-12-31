module Renalware::Pathology
  describe "Viewing patient investigations (a.k.a. obervation requests or OBRs)" do
    context "when the patient has no investigations" do
      it "displays nothing" do
        patient = create(:pathology_patient)
        login_as_clinical

        visit patient_pathology_observation_requests_path(patient)

        expect(page).to have_content("No investigations available for this patient.")
      end
    end

    context "when the patient has investigations", :js do
      it "displays a list of OBRs" do
        user = login_as_clinical
        patient = create(:pathology_patient, by: user)
        obr_desc = create(:pathology_request_description, name: "MyOBR", code: "OBRCode")
        obx_desc = create(:pathology_observation_description, name: "MyOBX")
        obr = create(
          :pathology_observation_request,
          patient: patient,
          description: obr_desc,
          requested_at: "2019-01-01"
        )
        obx = create(:pathology_observation, request: obr, description: obx_desc)

        visit patient_pathology_observation_requests_path(patient)

        within("#observation-requests") do
          # Displays a list of investgations (OBRs)
          expect(page).to have_content(obr_desc.name)
          expect(page).to have_content(l(obr.requested_at))
        end

        # Click on the OBR to load up the OBXes withinit
        click_on obr_desc.code

        # The OBX list loaded by ajax
        expect(page).to have_content(obr_desc.name)
        expect(page).to have_content(obr_desc.code)
        expect(page).to have_content(obx.result)

        # Click on the OBX name to see all similar OBXes
        click_on(obx_desc.name)

        # A list of all OBXes of this type (OBX description) for this patient
        expect(page).to have_current_path(patient_pathology_observations_path(patient, obx_desc))
        expect(page).to have_content(obx_desc.name)
        expect(page).to have_content(l(obr.requested_at)) # TODO: should be obx.observed_at ?
        expect(page).to have_content(obx.result)
      end

      context "when filtering by investigations" do
        it "shows a dropdown filter with only the OBRs the patient has had" do
          user = login_as_clinical
          patient = create(:pathology_patient, by: user)
          obr_desc1 = create(:pathology_request_description, name: "MyOBR1", code: "OBR1")
          obr_desc2 = create(:pathology_request_description, name: "MyOBR2", code: "OBR2")
          create(:pathology_observation_request, patient: patient, description: obr_desc1)
          create(:pathology_observation_request, patient: patient, description: obr_desc2)

          visit patient_pathology_observation_requests_path(patient)

          # It displays all the requests, unfiltered, by default
          expect(page).to have_content(obr_desc1.name)
          expect(page).to have_content(obr_desc2.name)

          # Exercise the options
          select "OBR1 - MyOBR1", from: "Filter by Code"
          select "OBR2 - MyOBR2", from: "Filter by Code"

          # Choose an option and click Filter
          click_on t("btn.filter")

          within("#observation-requests") do
            # It only displays the filtered OBRs
            expect(page).to have_content(obr_desc2.name)
            expect(page).to have_no_content(obr_desc1.name)
          end
        end
      end
    end
  end
end
