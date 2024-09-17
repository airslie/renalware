# frozen_string_literal: true

module Renalware::Letters::Transports::Mesh
  describe API::RequestHeaders do
    describe "#to_h" do
      subject do
        described_class.new(
          auth_header: "my-auth-header",
          to: "NHSNumber_DOB_Surname",
          subject: "document-title-and-patient-details-etc",
          operation_uuid: "operation_uuid"
        ).to_h
      end

      before do
        allow(Renalware.config).to receive_messages(
          mesh_organisation_ods_code: "ODS123",
          letters_mesh_workflow: :gp_connect,
          mesh_mailbox_id: "SendingMailbox1"
        )
      end

      it "returns a correctly populated hash of headers" do
        is_expected.to eq(
          "Authorization" => "my-auth-header",
          "Mex-ClientVersion" => "ApiDocs==0.0.1",
          "Mex-OSArchitecture" => "x86_64",
          "Mex-OSName" => "Linux",
          "Mex-OSVersion" => "",
          "Mex-FileName" => "None",
          "Mex-MessageType" => "DATA",
          "Mex-WorkflowID" => "GPFED_CONSULT_REPORT",
          "Mex-From" => "SendingMailbox1", # GPCM-SD-062
          "Mex-To" => "NHSNumber_DOB_Surname",
          "Mex-LocalID" => "ODS123", # GPCM-SD-146
          "X-OperationID" => "operation_uuid",
          "Mex-Subject" => "document-title-and-patient-details-etc",
          "Content-Type" => "application/xml"
        )
      end
    end
  end
end
