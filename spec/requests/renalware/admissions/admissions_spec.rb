# frozen_string_literal: true

module Renalware
  describe "Admission management" do
    include PatientsSpecHelper

    let(:user) { create(:user) }
    let(:time) { Time.zone.now }
    let(:hospital_ward) { create(:hospital_ward, name: "Ward1") }
    let(:patient) do
      create(:patient).tap do |pat|
        set_modality(
          patient: pat,
          modality_description: create(:hd_modality_description),
          by: user
        )
      end
    end

    def convert_hash_dates_to_string_using_locale(hash)
      hash.each { |key, val| hash[key] = l(val) if val.is_a?(Date) }
    end

    def create_admission
      create(:admissions_admission,
             by: user,
             patient: patient,
             admitted_on: Time.zone.today,
             admission_type: :unknown,
             reason_for_admission: "Reason",
             hospital_ward: hospital_ward)
    end

    describe "GET index", type: :system do
      it "lists admissions" do
        admission = create_admission
        login_as_clinical
        visit admissions_admissions_path

        within(".non-patient-page") do
          expect(body).to have_content("Inpatient Admissions")
          expect(body).to have_content("Ward1")
          expect(body).to have_content(admission.patient.to_s)
        end
      end
    end

    describe "GET new" do
      it "render the form" do
        get new_admissions_admission_path

        expect(response).to be_successful
        expect(response).to render_template(:new, format: :html)
      end
    end

    describe "POST JS create" do
      context "with valid inputs" do
        it "creates the admission" do
          expect(patient.current_modality).to be_present
          params = {
            patient_id: patient.id,
            hospital_ward_id: hospital_ward.id,
            admitted_on: "12-Dec-2017",
            admission_type: "unknown",
            reason_for_admission: "reason",
            consultant: "Mr X",
            discharge_destination: "home",
            discharge_summary: "summary",
            transferred_on: "11-Dec-2017",
            discharged_on: "10-Dec-2017",
            notes: "Notes",
            summarised_by_id: user.id
          }

          post admissions_admissions_path, params: { admissions_admission: params }

          follow_redirect!
          expect(response).to be_successful
          expect(response).to render_template(:index)

          admissions = Renalware::Admissions::Admission.all
          expect(admissions.length).to eq(1)
          admission = admissions.first

          # Do a direct diff on supplied params and the saved object's attributes, excluding
          # attributes that we don't care about.
          attribs = admission.attributes.symbolize_keys.except(
            :id,
            :updated_at,
            :created_at,
            :created_by_id,
            :updated_by_id,
            :deleted_at
          )
          convert_hash_dates_to_string_using_locale(attribs)

          expect(admission).to have_attributes(
            discharge_destination: "home",
            consultant: "Mr X",
            reason_for_admission: "reason",
            hospital_ward_id: hospital_ward.id,
            admitted_on: Time.zone.parse("12-Dec-2017"),
            transferred_on: Time.zone.parse("11-Dec-2017"),
            discharged_on: Time.zone.parse("10-Dec-2017"),
            notes: "Notes",
            discharge_summary: "summary",
            modality_at_admission: patient.current_modality,
            summarised_by_id: user.id
          )
        end
      end

      context "with invalid inputs" do
        it "re-renders the modal form with validation errors" do
          params = { patient_id: nil }

          post admissions_admissions_path, params: { admissions_admission: params }

          expect(response).to be_successful
          expect(response).to render_template(:new)
        end
      end
    end

    describe "GET html edit" do
      it "renders the form" do
        get edit_admissions_admission_path(create_admission)

        expect(response).to be_successful
        expect(response).to render_template(:edit)
      end
    end

    describe "PATCH html update" do
      context "with valid inputs" do
        it "updates the admission" do
          admission = create_admission
          hospital_ward2 = create(:hospital_ward, name: "Ward2")

          params = { hospital_ward_id: hospital_ward2.id }

          patch(admissions_admission_path(admission), params: { admissions_admission: params })

          follow_redirect!
          expect(response).to be_successful
          expect(response).to render_template(:index)
          expect(admission.reload.hospital_ward_id).to eq(hospital_ward2.id)
        end
      end

      context "with invalid inputs" do
        it "re-renders the modal form with validation errors" do
          admission = create_admission
          params = { hospital_ward_id: nil }

          patch(admissions_admission_path(admission), params: { admissions_admission: params })

          expect(response).to be_successful
          expect(response).to render_template(:edit)
        end
      end
    end

    describe "DELETE html destroy" do
      it "soft deletes the admission and sets the ended_on date to today" do
        admission = create_admission

        expect {
          delete admissions_admission_path(admission)
        }
          .to change(Admissions::Admission, :count).by(-1)
          .and change(Admissions::Admission.deleted, :count).by(1)
      end
    end
  end
end
