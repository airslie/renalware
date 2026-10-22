describe Renalware::EPR::MetadataXml do
  subject(:xml) do
    Nokogiri::XML(
      described_class.new(
        filename: "1_Letter.pdf",
        hospital_number: "0000345",
        section: "Clinical Notes & History",
        destination_label: "MDT_Meeting_Notes",
        document_name: "MDT_Meeting_Notes",
        document_id: 42,
        document_type: "CL06.080",
        document_date: "13-03-2025",
        renal_activity: "361"
      ).to_xml
    )
  end

  it "names the uploaded file" do
    expect(xml.at_xpath("/Batch/Files/FileUpload/@filename").value).to eq("1_Letter.pdf")
  end

  it "builds the destination path including the section, number, activity, date and id" do
    expect(xml.at_xpath("//DestinationPath").text).to eq(
      "\\Patient Records\\0000345\\Clinical Notes & History\\" \
      "0000345_MDT_Meeting_Notes_361_13-03-2025_(42).pdf"
    )
  end

  it "includes the document attributes" do
    attributes = {
      "PatientHospitalNumber" => "0000345",
      "Section" => "Clinical Notes & History",
      "DocumentType" => "CL06.080",
      "DocumentName" => "MDT_Meeting_Notes",
      "SpecialtyCode" => "361",
      "DocumentDate" => "13-03-2025",
      "DateScanned" => "13-03-2025",
      "JobName" => "Renal",
      "BatchReferenceNumber" => "null"
    }

    attributes.each do |element, text|
      expect(xml.at_xpath("//Attributes/#{element}").text).to eq(text)
    end
  end

  it "does not queue the file for scanning and versions it" do
    expect(xml.at_xpath("//AddToScanQueue").text).to eq("false")
    expect(xml.at_xpath("//VersionFile").text).to eq("true")
  end
end
