describe "Patient's Observations" do
  let(:patient) { create(:pathology_patient) }
  let(:observation_request) { create(:pathology_observation_request, patient:) }
  let(:description) { create(:pathology_observation_description) }
  let(:path) do
    patient_pathology_observations_path(patient_id: patient, description_id: description.id)
  end
  let(:observations) do
    Array.new(26) do |index|
      create(:pathology_observation,
             request: observation_request,
             description:,
             observed_at: Time.zone.parse("2026-01-01 12:00") + index.days,
             result: "#{index + 1}.5")
    end.reverse
  end

  def html_results
    response.parsed_body.css("#observations tbody tr td:last-child").map(&:text)
  end

  def results_for(format)
    format == :json ? response.parsed_body.fetch("results").map(&:last) : html_results
  end

  def expected_results(records, format)
    records.map { |observation| format == :json ? observation.result.to_f : observation.result }
  end

  shared_examples "a first-page fallback" do |format, page|
    it "treats page #{page.inspect} as the first page" do
      observations

      get path, params: { format:, page: }

      expect(response).to be_successful
      expect(results_for(format)).to eq(expected_results(observations.first(25), format))
    end
  end

  shared_examples "paginated observation history" do |format|
    it "returns 25 results newest first, restricted to the patient and description" do
      observations
      create(:pathology_observation, description:, result: "999")
      create(:pathology_observation, request: observation_request, result: "888")

      get path, params: { format:, per_page: 1, limit: 1 }

      expect(response).to be_successful
      expect(results_for(format)).to eq(expected_results(observations.first(25), format))
    end

    it "returns the remaining results on page two" do
      observations

      get path, params: { format:, page: 2 }

      expect(response).to be_successful
      expect(results_for(format)).to eq(expected_results(observations.last(1), format))
    end

    it_behaves_like "a first-page fallback", format, "0"
    it_behaves_like "a first-page fallback", format, "-1"
    it_behaves_like "a first-page fallback", format, "invalid"

    it "returns no results for an out-of-range page" do
      observations

      get path, params: { format:, page: 999 }

      expect(response).to be_successful
      expect(results_for(format)).to be_empty
    end

    it "handles a description with no observations" do
      get path, params: { format: }

      expect(response).to be_successful
      expect(results_for(format)).to be_empty
    end
  end

  context "with HTML" do
    it_behaves_like "paginated observation history", :html
  end

  context "with JSON" do
    it_behaves_like "paginated observation history", :json
  end

  it "provides working links to the next and previous pages" do
    observations
    get path

    next_link = response.parsed_body.at_css('a[rel="next"]')
    expect(next_link).to be_present
    get next_link["href"]
    expect(html_results).to eq(observations.last(1).map(&:result))

    previous_link = response.parsed_body.at_css('a[rel="prev"]')
    expect(previous_link).to be_present
    get previous_link["href"]
    expect(html_results).to eq(observations.first(25).map(&:result))
  end

  it "displays the empty history message" do
    get path

    expect(response.parsed_body.text)
      .to include("No observations of \"#{description.name}\" available for this patient.")
  end

  it "preserves the JSON metadata, dates and conversion of numeric and blank results" do
    create(:pathology_observation, request: observation_request, description:,
                                   observed_at: "2026-01-02 12:00", result: "12.5")
    create(:pathology_observation, request: observation_request, description:,
                                   observed_at: "2026-01-01 12:00", result: "")

    get path, params: { format: :json }

    expect(response.parsed_body).to eq(
      "code" => description.code,
      "name" => description.name,
      "results" => [["2026-01-02", 12.5], ["2026-01-01", 0.0]]
    )
  end
end
