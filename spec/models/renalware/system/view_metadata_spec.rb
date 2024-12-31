module Renalware::System
  describe ViewMetadata do
    it { is_expected.to have_many :calls }

    describe "#fully_qualified_view_name" do
      it "joins schema_name and view_name" do
        [
          ["schema", "view", "schema.view"],
          ["", "view", "view"],
          [nil, "view", "view"],
          ["schema", "", "schema"]
        ].each do |(schema, view, fqn)|
          expect(
            described_class.new(schema_name: schema, view_name: view).fully_qualified_view_name
          ).to eq(fqn)
        end
      end
    end

    describe "scope refreshable_materialised_views" do
      it "returns only rows where materialised is true and refresh_schedule is not blank" do
        create(:view_metadata, refresh_schedule: nil)
        create(:view_metadata, refresh_schedule: "")
        create(:view_metadata, refresh_schedule: "every minute", materialized: false)
        vmd = create(:view_metadata, refresh_schedule: "every minute", materialized: true)

        expect(described_class.refreshable_materialised_views).to eq([vmd])
      end
    end
  end
end
