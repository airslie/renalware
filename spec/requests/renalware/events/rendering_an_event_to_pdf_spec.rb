# frozen_string_literal: true

describe "Rendering an event to a PDF" do
  it "renders a PDF" do
    event = create(:simple_event)
    create(:hospital_centre, code: Renalware.config.ukrdc_site_code)

    get patient_event_path(event.patient, event, format: :pdf)

    expect(response).to be_successful
    expect(response["Content-Type"]).to eq("application/pdf")
    # filename = "RABBIT-KCH57837-#{letter.id}-DRAFT".upcase
    # expect(response["Content-Disposition"]).to include("attachment")
    # expect(response["Content-Disposition"]).to include(filename)
  end
end
