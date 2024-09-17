# frozen_string_literal: true

describe "Managing the patient worryboard" do
  let(:user) { @current_user }
  let(:patient) { create(:patient, by: user) }
  let(:worry_category) { create(:worry_category, name: "CategoryA") }

  describe "POST create" do
    context "when the patient has no worry (!)" do
      it "creates a new patient worry (aka adding them to the Worryboard)" do
        params = {
          patients_worry: {
            notes: "Abc",
            worry_category_id: worry_category.id
          }
        }
        post(patient_worry_path(patient), params: params)
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response).to be_successful

        worry = Renalware::Patients::Worry.find_by(patient_id: patient.id)
        expect(worry.notes).to eq("Abc")
        expect(worry.worry_category).to eq(worry_category)
      end
    end

    context "when the patient already has a worry (i.e. is on the worryboard)" do
      # Not expected to be possible in the UI but testing anyway
      it "behaves idempotently, does not fail, behaves as if the worry was just added" do
        Renalware::Patients::Worry.new(patient: patient, by: user, notes: "Abc").save!
        params = { patients_worry: { notes: nil } }
        post(patient_worry_path(patient), params: params)
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response).to be_successful

        expect(Renalware::Patients::Worry.find_by(patient_id: patient.id)).not_to be_nil
      end

      # Not expected to be possible in the UI but testing anyway
      # it "does not overwrite existing worry notes if no notes added this time" do
      #   Renalware::Patients::Worry.new(patient: patient, by: user, notes: "Abc").save!
      #   params = {
      #     patients_worry: {
      #       notes: "",
      #       worry_category_id: nil
      #     }
      #   }
      #   post(patient_worry_path(patient), params: params)
      #   expect(response).to have_http_status(:redirect)
      #   follow_redirect!
      #   expect(response).to be_successful

      #   worry = Renalware::Patients::Worry.find_by(patient_id: patient.id)
      #   expect(worry.notes).to eq("Abc")
      # end
    end

    describe "DELETE destroy" do
      it "soft deletes the worry" do
        worry = Renalware::Patients::Worry.new(patient: patient, by: user)
        worry.save!

        delete patient_worry_path(patient, worry)

        expect(response).to have_http_status(:redirect)
        expect(Renalware::Patients::Worry).not_to exist(id: worry.id)
      end

      it "does not baulk if the worry does not exist" do
        delete patient_worry_path(patient, id: 999)
        expect(response).to have_http_status(:redirect)
      end

      with_versioning do
        it "stores a papertrail version with the correct whodunnit value" do
          expect(PaperTrail).to be_enabled
          worry = Renalware::Patients::Worry.new(patient: patient, by: user)
          worry.save!

          delete patient_worry_path(patient, worry)

          expect(response).to have_http_status(:redirect)
          version = Renalware::Patients::Version.last
          expect(version.whodunnit.to_s).to eq(user.id.to_s)
          expect(version.event).to eq("destroy")
          expect(version.item_type).to eq("Renalware::Patients::Worry")
        end
      end
    end
  end
end
