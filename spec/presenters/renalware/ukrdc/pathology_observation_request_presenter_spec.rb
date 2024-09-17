# frozen_string_literal: true

module Renalware
  module UKRDC
    describe PathologyObservationRequestPresenter do
      describe "#placer_id which is a concatenation of several columns to " \
               "create a unique reference that identifies an HL7 OBR request" do
        subject { described_class.new(request).placer_id }

        context "when requestor_order_number requested_at description_id present" do
          let(:request) do
            Pathology::ObservationRequest.new(
              requestor_order_number: "A",
              requested_at: Time.zone.parse("2019-01-01 10:00:01"),
              description_id: 2
            )
          end

          it { is_expected.to eq "A-20190101100001000-2" }
        end
      end
    end
  end
end
