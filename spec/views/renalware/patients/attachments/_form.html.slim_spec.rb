describe "renalware/patients/attachments/_form" do
  let(:patient) { create(:patient) }

  before do
    patient_id = patient.id
    view.singleton_class.define_method(:patient_attachments_path) do |_arg = nil|
      "/patients/#{patient_id}/attachments"
    end
    view.singleton_class.define_method(:patient_attachment_path) do |_arg1 = nil, _arg2 = nil|
      "/patients/#{patient_id}/attachments/1"
    end
  end

  it "renders the pilot rw-form structure and attachment type data attributes" do
    create(:patient_attachment_type, name: "Standard", store_file_externally: false)
    create(:patient_attachment_type, name: "External", store_file_externally: true)
    attachment = build(:patient_attachment, patient:)

    render partial: "renalware/patients/attachments/form", locals: { attachment: }

    fragment = Nokogiri::HTML.fragment(rendered)

    expect(fragment.css("form.rw-form").size).to eq(1)
    expect(fragment.css(".rw-field-row").size).to be >= 4
    expect(rendered).to include("data-controller=\"flatpickr\"")
    expect(rendered).to include("rw-input--date")
    expect(rendered).to include("rw-input--sm")
    expect(rendered).to include("data-controller=\"patient-attachments\"")
    expect(rendered).to include("data-patient-attachments-target=\"externalLocation\"")
    expect(rendered).to include("data-patient-attachments-target=\"fileBrowser\"")
    expect(rendered).to include("data-store-file-externally=\"true\"")
  end

  it "marks immutable edit fields as disabled with explicit disabled styling class" do
    create(:patient_attachment_type, name: "Standard", store_file_externally: false)
    attachment = create(:patient_attachment, patient:, external_location: "X:/path/file.pdf")

    render partial: "renalware/patients/attachments/form", locals: { attachment: }

    fragment = Nokogiri::HTML.fragment(rendered)
    disabled_inputs = fragment.css(".rw-input--disabled[disabled]")

    expect(disabled_inputs.size).to be >= 2
    expect(rendered).to include("patients_attachment[attachment_type_id]")
    expect(rendered).to include("patients_attachment[external_location]")
  end
end
