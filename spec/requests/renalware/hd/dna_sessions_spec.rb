# frozen_string_literal: true

describe "Managing an HD DNA Session" do
  describe "GET show" do
    it "renders successfully" do
      dna_session = create(:hd_dna_session)
      get patient_hd_session_path(patient_id: dna_session.patient, id: dna_session.id)

      expect(response).to be_successful
    end

    context "when the session is still mutable" do
      it "renders successfully" do
        dna_session = create(:hd_dna_session)
        get edit_patient_hd_session_path(patient_id: dna_session.patient, id: dna_session.id)

        expect(response).to be_successful
      end
    end

    context "when the session is no longer mutable" do
      it "redirects to #show with a flash message", type: :system do
        dna_session = travel_to(Time.zone.now - 1.day) do
          create(:hd_dna_session)
        end

        route_params = { patient_id: dna_session.patient, id: dna_session.id }
        show_path = patient_hd_session_path(route_params)
        login_as_clinical
        edit_path = edit_patient_hd_session_path(route_params)

        visit edit_path

        # Disallows edit and redirect to the show page
        expect(page).to have_current_path(show_path)
      end
    end
  end
end
