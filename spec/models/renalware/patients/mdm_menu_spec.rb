module Renalware::Patients
  describe MDMMenu do
    describe ".items" do
      before do
        described_class.cached_items = nil
      end

      it "returns one menu item per mdm view and uses view_name when slug is blank" do
        create(
          :view_metadata,
          category: "mdm",
          scope: "hd",
          title: "All",
          slug: "all",
          view_name: "hd_mdm_patients"
        )
        create(
          :view_metadata,
          category: "mdm",
          scope: "hd",
          title: "Home HD",
          slug: nil,
          view_name: "my_view"
        )

        expect(described_class.items).to contain_exactly(
          described_class::MenuItem.new(scope: "hd", title: "HD", filter: "all"),
          described_class::MenuItem.new(scope: "hd", title: "Home HD", filter: "my_view")
        )
      end
    end
  end
end
