# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Searching patients", type: :request do
  describe "GET index" do
    context "with a hospital code filter" do
      before do
        create(:patient, local_patient_id: "::target number::")
        create(:patient, local_patient_id: "::another number::")
      end

      it "responds with a filtered list of records matching the hospital number" do
        get patients_path(q: { identity_match: "::target number::" })

        expect(response).to have_http_status(:success)
        expect(response.body).to match("::target number::")
      end
    end

    context "with a partial family name and given name filter" do
      before do
        create(:patient, given_name: "Roger", family_name: "Rabbit")
        create(:patient, family_name: "::another patient::")
      end

      it "responds with a filtered list of records matching the hospital number" do
        get patients_path(q: { identity_match: "rabb r" })

        expect(response).to have_http_status(:success)
        expect(response.body).to match("RABBIT")
      end
    end

    context "with a partial family name and given name filter using a comma delimiter" do
      before do
        create(:patient, given_name: "Roger", family_name: "Rabbit")
        create(:patient, family_name: "::another patient::")
      end

      it "responds with a filtered list of records matching the hospital number" do
        get patients_path(q: { identity_match: "rabb,r" })

        expect(response).to have_http_status(:success)
        expect(response.body).to match("RABBIT")
      end
    end

    context "with a partial family name and given name filter using a comma + space delimiter" do
      before do
        create(:patient, given_name: "Roger", family_name: "Rabbit")
        create(:patient, family_name: "::another patient::")
      end

      it "responds with a filtered list of records matching the hospital number" do
        get patients_path(q: { identity_match: "rabb, r" })

        expect(response).to have_http_status(:success)
        expect(response.body).to match("RABBIT")
      end
    end

    context "with a family name filter" do
      before do
        create(:patient, given_name: "Roger", family_name: "Rabbit")
        create(:patient, family_name: "::another patient::")
      end

      it "responds with a filtered list of records matching the hospital number" do
        get patients_path(q: { identity_match: "rabbit" })

        expect(response).to have_http_status(:success)
        expect(response.body).to match("RABBIT")
      end
    end

    context "with a NHS number filter" do
      before do
        create(:patient, nhs_number: "1234567890")
        create(:patient, nhs_number: "9999999999")
      end

      it "responds with a filtered list of records matching the NHS number" do
        get patients_path(q: { identity_match: "1234567890" })

        expect(response).to have_http_status(:success)
        expect(response.body).to match("1234567890")
      end

      context "when the NHS number is entered in the 3-groups-separated-with-spaces format" do
        it "responds with a filtered list of records matching the NHS number" do
          get patients_path(q: { identity_match: "123 456 7890" })

          expect(response).to have_http_status(:success)
          expect(response.body).to match("123 456 7890")
        end
      end
    end
  end
end
