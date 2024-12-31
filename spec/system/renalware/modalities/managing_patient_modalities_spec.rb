describe "Managing a patient's modalities", js: false do
  let(:patient) { create(:patient) }
  let(:tx_mod_desc) { create(:modality_description, :transplant) }
  let(:hd_mod_desc) { create(:modality_description, :hd) }
  let(:pd_mod_desc) { create(:modality_description, :pd) }

  def change_patient_modality(patient, modality_description, user, started_on: Time.zone.now)
    result = Renalware::Modalities::ChangePatientModality
      .new(patient: patient, user: user)
      .call(description: modality_description, started_on: started_on)
    expect(result).to be_success
    patient.reload
    result.object
  end

  before do
    create(:modality_change_type, :other, default: true)
    allow(Renalware.config).to receive(:allow_modality_history_amendments).and_return(true)
  end

  pending "adding a modality"

  describe "listing modalities" do
    context "when two modalities overlap" do
      it "displays a warning" do
        user = login_as_super_admin

        pd_modality = change_patient_modality(
          patient, pd_mod_desc, user, started_on: "2022-01-01"
        )
        change_patient_modality(
          patient, hd_mod_desc, user, started_on: "2023-01-01"
        )
        # Let's set the old pd_modality end_date to overlap by 1d with the hd_modality start_date
        pd_modality.update!(ended_on: "2023-01-02")

        visit patient_modalities_path(patient)
        within("#patient-modalities") do
          expect(page).to have_css("tbody tr", count: 3) # 1 = hd, 2 = overlap msg, 3 = pd
          expect(page).to have_content(
            "Overlapping modality dates 02-Jan-2023 and 01-Jan-2023 (1 day)"
          )
        end
      end
    end

    context "when two modalities leave a gap" do
      it "displays a warning" do
        user = login_as_super_admin

        pd_modality = change_patient_modality(
          patient, pd_mod_desc, user, started_on: "2022-01-01"
        )
        change_patient_modality(
          patient, hd_mod_desc, user, started_on: "2023-01-01"
        )
        # Let's set the old pd_modality end_date to fall short and leave a 2d gap
        # before the start of the hd_modality
        pd_modality.update!(ended_on: "2022-12-30")

        visit patient_modalities_path(patient)
        within("#patient-modalities") do
          expect(page).to have_css("tbody tr", count: 3) # 1 = hd, 2 = missing mod msg, 3 = pd
          expect(page).to have_content(
            "Missing modality data between 30-Dec-2022 and 01-Jan-2023 (2 days)"
          )
        end
      end
    end

    context "when there is 0 day gap between modalities" do
      it "no warning is shown" do
        user = login_as_super_admin

        pd_modality = change_patient_modality(
          patient, pd_mod_desc, user, started_on: "2022-01-01"
        )
        hd_modality = change_patient_modality(
          patient, hd_mod_desc, user, started_on: "2023-01-01"
        )
        # Sanity check that change_patient_modality has wired update pd ended_on correctly
        expect(pd_modality.reload.ended_on).to eq(hd_modality.started_on)

        visit patient_modalities_path(patient)
        within("#patient-modalities") do
          expect(page).to have_css("tbody tr", count: 2) # 1 = hd, 2 = pd
        end
      end
    end
  end

  describe "editing a modality" do
    context "when the patient has only one modality and we edit it" do
      it "we can edit the start date end dates to both be in the past, " \
         "and the modality will be terminated" do
        travel_to Time.zone.parse("2023-10-01 00:00:00") do
          pd_mod_desc # Make PD modality option available
          user = login_as_super_admin
          modality = change_patient_modality(patient, hd_mod_desc, user)
          visit patient_modalities_path(patient)

          within("#modalities_modality_#{modality.id}") do
            click_on "Amend"
          end

          select "PD", from: "Description"
          fill_in "Started on", with: "2023-09-01"
          fill_in "Ended on", with: "2023-09-02"
          click_on "Save"

          expect(page).to have_current_path(patient_modalities_path(patient))

          within "##{dom_id(modality)}" do
            expect(page).to have_content("PD")
          end

          expect(modality.reload).to have_attributes(
            started_on: Date.parse("2023-09-01"),
            ended_on: Date.parse("2023-09-02"),
            description_id: pd_mod_desc.id,
            state: "terminated"
          )
        end
      end
    end

    context "when patient has two modalities" do
      it "we can change the date boundary between them" do
        travel_to Time.zone.parse("2023-10-01 00:00:00") do
          user = login_as_super_admin
          pd_modality = change_patient_modality(
            patient, pd_mod_desc, user, started_on: "2022-01-01"
          )
          hd_modality = change_patient_modality(
            patient, hd_mod_desc, user, started_on: "2023-01-01"
          )

          # At this point the patient has two modalities
          #    started     ended       state
          # PD 2022-01-01  2023-01-01  terminated
          # HD 2023-01-01              current

          # We want to simulate changing the border between the two to this
          #    started     ended       state
          # PD 2022-01-01  2022-12-01  terminated
          # HD 2022-12-01              current
          visit patient_modalities_path(patient)

          # Change PD
          within("##{dom_id(pd_modality)}") do
            click_on "Amend"
          end
          fill_in "Ended on", with: "2022-12-01"
          click_on "Save"
          expect(page).to have_current_path(patient_modalities_path(patient))

          # Change HD
          within("##{dom_id(hd_modality)}") do
            click_on "Amend"
          end
          fill_in "Started on", with: "2022-12-01"
          click_on "Save"
          expect(page).to have_current_path(patient_modalities_path(patient))

          expect(pd_modality.reload).to have_attributes(
            ended_on: Date.parse("2022-12-01"),
            state: "terminated"
          )

          expect(hd_modality.reload).to have_attributes(
            started_on: Date.parse("2022-12-01"),
            state: "current"
          )
        end
      end

      it "sets state to current when the most recent modality's termination date is removed" do
        travel_to Time.zone.parse("2023-10-01 00:00:00") do
          user = login_as_super_admin
          change_patient_modality(
            patient, pd_mod_desc, user, started_on: "2022-01-01"
          )
          hd_modality = change_patient_modality(
            patient, hd_mod_desc, user, started_on: "2023-01-01"
          )

          # At this point the patient has two modalities
          #    started     ended       state
          # PD 2022-01-01  2023-01-01  terminated
          # HD 2023-01-01              current

          visit patient_modalities_path(patient)

          # Terminate the current modality manually
          within("##{dom_id(hd_modality)}") do
            click_on "Amend"
          end
          fill_in "Ended on", with: "2023-01-01"
          click_on "Save"
          expect(page).to have_current_path(patient_modalities_path(patient))

          expect(hd_modality.reload.state).to eq("terminated")

          # Now edit it again to remove the terminated date so it becomes current again
          within("##{dom_id(hd_modality)}") do
            click_on "Amend"
          end
          fill_in "Ended on", with: ""
          click_on "Save"
          expect(page).to have_current_path(patient_modalities_path(patient))

          expect(hd_modality.reload.state).to eq("current")
        end
      end
    end
  end

  describe "deleting a modality" do
    context "when there is only one modality" do
      it "user is left with no modality" do
        user = login_as_super_admin
        modality = change_patient_modality(patient, hd_mod_desc, user)
        visit patient_modalities_path(patient)

        within("#modalities_modality_#{modality.id}") do
          expect {
            click_on "Delete"
          }.to change(Renalware::Modalities::Modality, :count).by(-1)
        end
      end
    end

    context "when deleting the current modality and there is preceding one" do
      it "the preceding one becomes the current modality" do
        user = login_as_super_admin
        _tx_modality = change_patient_modality(patient, tx_mod_desc, user, started_on: "2021-01-01")
        pd_modality = change_patient_modality(patient, pd_mod_desc, user, started_on: "2022-01-01")
        hd_modality = change_patient_modality(patient, hd_mod_desc, user, started_on: "2023-01-01")
        visit patient_modalities_path(patient)

        expect(patient.reload.current_modality).to eq(hd_modality)
        expect(hd_modality.reload.state).to eq("current")
        expect(pd_modality.reload.state).to eq("terminated")

        within("#modalities_modality_#{hd_modality.id}") do
          expect {
            click_on "Delete"
          }.to change(Renalware::Modalities::Modality, :count).by(-1)
        end

        expect(patient.reload.current_modality).to be_present
        expect(patient.reload.current_modality).to have_attributes(
          description_id: pd_mod_desc.id,
          started_on: Date.parse("2022-01-01"),
          state: "current",
          ended_on: nil
        )
      end
    end
  end
end
