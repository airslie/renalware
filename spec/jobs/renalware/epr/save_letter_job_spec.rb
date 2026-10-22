describe Renalware::EPR::SaveLetterJob do
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
    expect(xml.at_xpath("//FileUpload/@filename").value).to eq(
      Renalware::EPR::LetterFilename.new(letter, :DVH).to_s
    )
  end
end
