# frozen_string_literal: true

module Renalware
  describe Pathology::Charts::Chart do
    it :aggregate_failures do
      is_expected.to have_many(:series)
      is_expected.to validate_presence_of(:title)
      # Chartable 'interface'
      is_expected.to respond_to(:chart_series_json)
      is_expected.to respond_to(:axis_label)
      is_expected.to respond_to(:axis_type)
      is_expected.to respond_to(:title)
    end

    describe "#default_scope" do
      it "excludes disabled charts" do
        enabled_chart = create(:pathology_chart)
        create(:pathology_chart, enabled: false)

        expect(described_class.all).to eq([enabled_chart])
      end
    end
  end
end
