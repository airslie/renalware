describe Renalware::EPR::SaveLetterJob do
  include ActiveJob::TestHelper
  include LettersSpecHelper

  let(:folder) { Rails.root.join("tmp/epr_spec_#{SecureRandom.hex(4)}") }
  let(:pdf_path) { folder.join("letters/test.pdf") }
  let(:patient) do
    create(
      :letter_patient,
      local_patient_id_3: "345",
      family_name: "Smith",
      born_on: Date.new(2013, 1, 1)
    )
  end
  let(:letter) do
    create_letter(
      state: :approved,
      to: :patient,
      patient:,
      approved_at: Time.zone.parse("2025-03-13 10:31:06")
    )
  end

  include_context "with DVH as the EPR site"

  after { FileUtils.rm_rf(folder) }

  it "writes the PDF and an XML sidecar with the same basename" do
    described_class.new.perform(letter:, file_path: pdf_path.to_s)

    expect(pdf_path).to exist
    expect(pdf_path.sub_ext(".xml")).to exist
  end

  it "describes the letter in the XML sidecar" do
    described_class.new.perform(letter:, file_path: pdf_path.to_s)

    xml = Nokogiri::XML(pdf_path.sub_ext(".xml").read)
    expect(xml.at_xpath("//PatientHospitalNumber").text).to eq("0000345")
    expect(xml.at_xpath("//DocumentType").text).to eq("CO03.011")
    expect(xml.at_xpath("//SpecialtyCode").text).to eq("361")
    expect(xml.at_xpath("//DocumentDate").text).to eq("13-03-2025")
    expect(xml.at_xpath("//FileUpload/@filename").value).to eq(pdf_path.basename.to_s)
  end

  it "references the queued PDF path after patient demographics change" do
    ActiveJob::Base.queue_adapter = :test
    filename = Renalware::EPR::LetterFilename.new(letter, :DVH).to_s
    path = folder.join(filename)
    described_class.perform_later(letter:, file_path: path.to_s)
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
