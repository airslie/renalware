RSpec.describe Relay::GPConnect::Mesh::RequestHeaders do
  describe "#to_h" do
    subject(:headers) do
      described_class.new(
        config: build_mesh_config(mailbox_id: "SendingMailbox1"),
        auth_header: "my-auth-header",
        to: "NHSNumber_DOB_Surname",
        subject: "document-title-and-patient-details-etc",
        operation_uuid: "operation_uuid"
      ).to_h
    end

    it "returns a correctly populated hash of headers" do
      expect(headers).to eq(
        "Authorization" => "my-auth-header",
        "Mex-ClientVersion" => "ApiDocs==0.0.1",
        "Mex-OSArchitecture" => "x86_64",
        "Mex-OSName" => "Linux",
        "Mex-OSVersion" => "",
        "Mex-FileName" => "None",
        "Mex-MessageType" => "DATA",
        "Mex-WorkflowID" => "GPCONNECT_SEND_DOCUMENT",
        "Mex-From" => "SendingMailbox1", # GPCM-SD-062
        "Mex-To" => "NHSNumber_DOB_Surname",
        "Mex-LocalID" => "operation_uuid", # GPCM-SD-146
        "X-OperationID" => "operation_uuid",
        "Mex-Subject" => "document-title-and-patient-details-etc",
        "Content-Type" => "application/xml"
      )
    end

    it "takes the workflow id from the config" do
      other = described_class.new(config: build_mesh_config(workflow_id: "OTHER_WORKFLOW")).to_h

      expect(other["Mex-WorkflowID"]).to eq("OTHER_WORKFLOW")
    end

    it "generates an authorization header from the config when none is given" do
      generated = described_class.new(config: build_mesh_config).to_h

      expect(generated["Authorization"]).to start_with("NHSMESH RAJ01OT001:")
    end
  end
end
