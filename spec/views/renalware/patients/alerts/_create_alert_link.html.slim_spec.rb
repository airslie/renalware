describe "renalware/patients/alerts/_create_alert_link" do
  it "renders the alert link with an inline icon and its modal wiring" do
    patient = build_stubbed(:patient)

    render partial: "renalware/patients/alerts/create_alert_link",
           locals: { patient:, link_text: "Add alert" }

    link = Nokogiri::HTML.fragment(rendered).at_css("a")
    expect(link.text.strip).to eq("Add alert")
    expect(link["href"]).to eq(new_patient_alert_path(patient_id: patient, format: :html))
    expect(link["data-reveal-id"]).to eq("create-alert-modal")
    expect(link["data-reveal-ajax"]).to eq("true")
    expect(link.at_css("svg")).to be_present
  end
end
