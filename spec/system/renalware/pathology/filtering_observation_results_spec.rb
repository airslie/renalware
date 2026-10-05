module Renalware::Pathology
  describe "Filtering patient pathology results", :js do
    %w(recent historical).each do |view|
      it "allows switching between empty and populated groups in the #{view} results view" do
        empty_message = "No results available for this patient in the selected code group."
        user = login_as_clinical
        patient = create(:pathology_patient, by: user)
        default_group = create(:pathology_code_group, :default, title: "Default")
        create(:pathology_code_group_membership, code_group: default_group, by: user)
        group = create(:pathology_code_group, name: "virology", title: "Virology")
        description = create(:pathology_observation_description, code: "VIR")
        create(:pathology_code_group_membership, code_group: group,
                                                 observation_description: description, by: user)
        request = create(:pathology_observation_request, patient:)
        create(:pathology_observation, request:, description:, result: "Positive")

        visit public_send("patient_pathology_#{view}_observations_path", patient)

        expect(page).to have_css("turbo-frame#path")
        expect(page).to have_select("filter_form_code_group_name", selected: "Default")
        expect(page).to have_text(empty_message)
        expect(page).to have_no_css("#path table")

        select "Virology", from: "filter_form_code_group_name"

        expect(page).to have_css("#path table", text: "Positive")
        expect(page).to have_no_text("No results available")
        expect(page).to have_select("filter_form_code_group_name", selected: "Virology")

        select "Default", from: "filter_form_code_group_name"

        expect(page).to have_text(empty_message)
        expect(page).to have_no_css("#path table")
        expect(page).to have_select("filter_form_code_group_name", selected: "Default")
      end
    end
  end
end
