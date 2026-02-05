module Renalware
  describe Help::Tours::Page do
    it :aggregate_failures do
      is_expected.to validate_presence_of(:route)
      is_expected.to have_many(:annotations)
    end

    describe "uniqueness" do
      subject { described_class.new(route: "foo") }

      it { is_expected.to validate_uniqueness_of(:route).case_insensitive }
    end

    describe "json_for" do
      let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }

      before do
        allow(Rails).to receive(:cache).and_return(memory_store)
        Rails.cache.clear
      end

      it "returns nil if request is nil" do
        json = described_class.json_for(nil)

        expect(json).to eq("{}")
      end

      it "returns nil if request.route_uri_pattern is nil" do
        request = instance_double(ActionDispatch::Request, route_uri_pattern: nil)
        json = described_class.json_for(request)

        expect(json).to eq("{}")
      end

      it "returns nil if request.route_uri_pattern does not match" do
        request = instance_double(ActionDispatch::Request, route_uri_pattern: "foo")
        json = described_class.json_for(request)

        expect(json).to eq("{}")
      end

      it "returns a Page object if request.route_uri_pattern matches without format" do
        request = instance_double(ActionDispatch::Request, route_uri_pattern: "foo(format: :html)")
        foo_page = described_class.create!(route: "foo")
        annotation3 = foo_page.annotations.create!(
          title: "Title3",
          text: "Text3",
          attached_to_selector: "selector3",
          position: 3
        )
        annotation1 = foo_page.annotations.create!(
          title: "Title1",
          text: "Text1",
          attached_to_selector: "selector1",
          position: 1
        )

        json = described_class.json_for(request)

        expected_json = {
          id: foo_page.id,
          route: "foo",
          annotations: [
            {
              id: annotation1.id,
              title: "Title1",
              text: "Text1",
              attachTo: {
                element: "selector1",
                on: annotation1.attached_to_position
              }
            },
            {
              id: annotation3.id,
              title: "Title3",
              text: "Text3",
              attachTo: {
                element: "selector3",
                on: annotation3.attached_to_position
              }
            }
          ]
        }.to_json

        expect(json).to eq(expected_json)
      end

      describe "caching" do
        let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }

        before do
          allow(Rails).to receive(:cache).and_return(memory_store)
          Rails.cache.clear
        end

        it "caches the built JSON response" do
          allow(Renalware.config)
            .to receive(:help_tours_page_cache_expiry_seconds)
            .and_return(0)
          cache_args = [
            "foo",
            {
              expires_in: 0.seconds,
              namespace: "help_tours"
            }
          ]
          allow(Rails.cache).to receive(:fetch).with(*cache_args).and_return({})
          request = instance_double(
            ActionDispatch::Request,
            route_uri_pattern: "foo(format: :html)"
          )

          described_class.json_for(request)

          expect(Rails.cache).to have_received(:fetch).with(*cache_args)
        end
      end
    end
  end
end
