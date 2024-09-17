# frozen_string_literal: true

describe "Managing patients" do
  let(:user) { @current_user }
  let(:patient) { create(:patient, by: user) }
  let(:algeria) { create(:algeria) }

  describe "GET new" do
    it "responds with a form" do
      get new_patient_path

      expect(response).to be_successful
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new record" do
        attributes = attributes_for(
          :patient,
          country_of_birth_id: algeria.id,
          local_patient_id: "abc123",
          local_patient_id_2: "xyz123"
        )
        document = build_document

        allow(Renalware::Patients::BroadcastPatientAddedEvent).to receive(:call)

        post patients_path, params: { patient: attributes.merge(document: document) }

        expect(response).to have_http_status(:redirect)
        created_patient = Renalware::Patient.find_by(nhs_number: attributes[:nhs_number])
        expect(created_patient).to be_present

        expect(created_patient.document).to match_document(document)
        expect(created_patient).to have_attributes(
          country_of_birth: algeria,
          created_by: @current_user,
          updated_by: @current_user,
          local_patient_id: "ABC123",
          local_patient_id_2: "XYZ123"
        )

        follow_redirect!

        expect(response).to be_successful
        expect(Renalware::Patients::BroadcastPatientAddedEvent).to have_received(:call)
      end
    end

    context "with invalid attributes" do
      it "responds with form" do
        attributes = { given_name: "" }
        post patients_path, params: { patient: attributes }

        expect(response).to be_successful
      end
    end
  end

  describe "GET edit" do
    it "responds with a form" do
      get edit_patient_path(patient)

      expect(response).to be_successful
    end
  end

  describe "PATCH update" do
    context "with valid attributes" do
      it "updates a record" do
        attributes = { given_name: "My Edited Patient", next_of_kin: "ABC" }
        patch patient_path(patient), params: { patient: attributes }

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Patient).to exist(attributes)

        updated_patient = Renalware::Patient.find_by(attributes)
        expect(updated_patient.updated_by).to eq(@current_user)

        follow_redirect!

        updated_patient = Renalware::Patient.find_by(attributes)
        expect(updated_patient).to have_attributes(
          updated_by: @current_user,
          next_of_kin: "ABC"
        )

        expect(response).to be_successful
      end
    end

    context "with invalid attributes" do
      it "responds with a form" do
        attributes = { given_name: "" }
        patch patient_path(patient), params: { patient: attributes }

        expect(response).to be_successful
      end
    end

    it "updates UKRDC anonymisation attributes" do
      attributes = {
        ukrdc_anonymise: true,
        ukrdc_anonymise_decision_on: Date.parse("01-01-2024"),
        ukrdc_anonymise_recorded_by: "Dr John"
      }
      patch patient_path(patient), params: { patient: attributes }

      expect(response).to have_http_status(:redirect)
      expect(Renalware::Patient).to exist(attributes)

      updated_patient = Renalware::Patient.find_by(attributes)
      expect(updated_patient.updated_by).to eq(@current_user)

      follow_redirect!

      updated_patient = Renalware::Patient.find_by(attributes)
      expect(updated_patient).to have_attributes(
        attributes
      )

      expect(response).to be_successful
    end
  end

  def build_document
    {
      interpreter_notes: Faker::Lorem.sentence,
      admin_notes: Faker::Lorem.sentence,
      special_needs_notes: Faker::Lorem.sentence,
      history: {
        alcohol: nil,
        smoking: nil
      },
      diabetes: {
        diagnosis: nil,
        diagnosed_on: nil
      },
      referral: {
        referring_physician_name: Faker::Name.name,
        referral_date: Faker::Date.backward(days: 14),
        referral_type: "Unknown",
        referral_notes: Faker::Lorem.sentence
      },
      psychosocial: {
        housing: Faker::Lorem.sentence,
        social_network: Faker::Lorem.sentence,
        care_package: Faker::Lorem.sentence,
        other: Faker::Lorem.sentence,
        updated_at: Date.parse("2012-12-12")
      }
    }
  end

  def address_attributes
    attributes_for(:address)
      .merge(
        name: Faker::Name.name,
        organisation_name: Faker::Company.name,
        street_2: Faker::Address.street_name,
        town: Faker::Address.city,
        county: Faker::Address.state,
        country: Faker::Address.country
      )
  end
end
