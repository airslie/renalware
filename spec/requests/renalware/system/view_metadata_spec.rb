describe Renalware::System::ViewMetadata do
  describe "#edit HTML" do
    it "renders a form" do
      view = create(:view_metadata)

      get edit_system_view_metadatum_path(view)

      expect(response).to be_successful
      expect(response.body).to match("Edit")
    end
  end

  context "when params are valid" do
    describe "#update HTML" do
      it "updates view metadata columns" do
        view = create(:view_metadata)
        attributes = attributes_for(:view_metadata)
        attributes[:columns] = [{ code: :sex, width: :small }]

        patch(
          system_view_metadatum_path(view),
          params: { view_metadata: attributes }
        )

        expect(response).to be_redirect
        follow_redirect!

        expect(view.reload.columns.as_json).to eq(
          [{
            "code" => "sex",
            "name" => nil,
            "hidden" => false,
            "width" => "small",
            "truncate" => false
          }]
        )
      end
    end
  end

  describe "#restore HTML" do
    it "restores metadata to a previous version" do
      with_versioning do
        dates = ["2012-01-01 23:00:01"]
        view = nil
        travel_to dates.first do
          view = create(:view_metadata)
          view.update!(description: "xyz")
        end
        view.update!(description: "123")

        expect(view.versions.count).to eq(3) # create, update, update

        # restore a version from 2012
        patch(restore_system_view_metadatum_path(view, version_at: dates.first.to_s))

        expect(response).to be_redirect
        follow_redirect!
        view.reload
        expect(view.versions.count).to eq(4)
        expect(view.description).to eq("xyz")
      end
    end
  end
end
