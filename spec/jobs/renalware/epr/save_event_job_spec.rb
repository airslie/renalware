describe Renalware::EPR::SaveEventJob do
  include ActiveJob::TestHelper

  let(:folder) { Rails.root.join("tmp/epr_spec_#{SecureRandom.hex(4)}") }
  let(:pdf_path) { folder.join("events/test.pdf") }
  let(:patient) { create(:patient, local_patient_id_3: "345") }
  let(:event) { create(:simple_event, patient:) }

  before { create(:hospital_centre, code: Renalware.config.ukrdc_site_code) }

  include_context "with DVH as the EPR site"

  after { FileUtils.rm_rf(folder) }

  it "writes the PDF and an XML sidecar with the same basename" do
    described_class.new.perform(event:, file_path: pdf_path.to_s)

    expect(pdf_path).to exist
    expect(pdf_path.sub_ext(".xml")).to exist
  end

  it "describes the MDT event in the XML sidecar" do
    described_class.new.perform(event:, file_path: pdf_path.to_s)

    xml = Nokogiri::XML(pdf_path.sub_ext(".xml").read)
    expect(xml.at_xpath("//PatientHospitalNumber").text).to eq("0000345")
    expect(xml.at_xpath("//DocumentType").text).to eq("CL06.080")
    expect(xml.at_xpath("//DocumentDate").text).to eq(event.created_at.strftime("%d-%m-%Y"))
    expect(xml.at_xpath("//FileUpload/@filename").value).to eq(pdf_path.basename.to_s)
  end

  it "references the queued PDF path after patient demographics change" do
    ActiveJob::Base.queue_adapter = :test
    filename = Renalware::EPR::MdtFilename.new(event, :DVH).to_s
    path = folder.join(filename)
    described_class.perform_later(event:, file_path: path.to_s)
    patient.update_columns(
      family_name: "Jones", born_on: Date.new(1980, 2, 3), local_patient_id_3: "678"
    )

    perform_enqueued_jobs(only: described_class)

    expect(path).to exist
    xml = Nokogiri::XML(path.sub_ext(".xml").read)
    expect(xml.at_xpath("//FileUpload/@filename").value).to eq(path.basename.to_s)
    expect(xml.at_xpath("//PatientHospitalNumber").text).to eq("0000678")
    expect(xml.at_xpath("//DestinationPath").text).to include("\\0000678\\")
  end
end
