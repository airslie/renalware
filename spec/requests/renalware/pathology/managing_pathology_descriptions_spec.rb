# frozen_string_literal: true

module Renalware::Pathology
  describe "Managing pathology observation descriptions (OBX)" do
    # Index HTML GET
    it "responds with a list" do
      create(:pathology_observation_description, code: "ABCD", name: "1234")

      get pathology_observation_descriptions_path

      expect(response).to be_successful

      expect(response.body).to match("Observation descriptions")
      expect(response.body).to match("ABCD")
      expect(response.body).to match("1234")
    end

    # Edit HTML GET
    it "responds with a form" do
      obx = create(:pathology_observation_description, code: "ABCD", name: "1234")

      get edit_pathology_observation_description_path(obx)

      expect(response).to be_successful
      expect(response.body).to match("ABCD")
    end

    # Update HTML PATCH
    context "when params valid" do
      it "updates a record" do
        obx = create(:pathology_observation_description, name: "1234")
        params = {
          pathology_observation_description: {
            name: "New name",
            lower_threshold: 1.1,
            upper_threshold: 20.1
          }
        }

        patch pathology_observation_description_path(obx), params: params

        expect(response).to be_redirect
        expect(obx.reload).to have_attributes(params[:pathology_observation_description])
      end
    end

    context "when paramas invalid" do
      it "fails to update and redisplays the edit form" do
        obx = create(:pathology_observation_description)
        params = {
          pathology_observation_description: {
            lower_threshold: 100.1,
            upper_threshold: 20.1
          }
        }

        patch pathology_observation_description_path(obx), params: params

        expect(response).to render_template("edit")
      end
    end
  end
end
