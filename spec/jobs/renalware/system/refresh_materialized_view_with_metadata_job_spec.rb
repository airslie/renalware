module Renalware
  describe System::RefreshMaterializedViewWithMetadataJob do
    let(:view_metadata) do
      create(
        :view_metadata,
        materialized: materialized,
        view_name: "test",
        schema_name: "xxx",
        refresh_concurrently: true
      )
    end

    let(:materialized) { true }
    let(:postgres_adapter) {
      instance_double(Scenic::Adapters::Postgres, refresh_materialized_view: nil)
    }

    describe "#perform" do
      before do
        allow(Scenic).to receive(:database).and_return postgres_adapter
      end

      context "when view is materialized" do
        it "refreshes the materialized view through Scenic" do
          described_class.perform_now(view_metadata)
          expect(postgres_adapter).to have_received(:refresh_materialized_view)
            .with \
              "xxx.test",
              cascade: false,
              concurrently: true
          expect(view_metadata.materialized_view_refreshed_at)
            .to be_within(3.seconds).of(Time.zone.now)
        end
      end

      context "when view is not materialized" do
        let(:materialized) { false }

        it "doesn't call Scenic" do
          described_class.perform_now(view_metadata)
          expect(Scenic).not_to have_received(:database)
          expect(view_metadata.materialized_view_refreshed_at).to be_nil
        end
      end
    end
  end
end
