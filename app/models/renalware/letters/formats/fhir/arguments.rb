module Renalware
  module Letters::Formats::FHIR
    # The gem's Arguments, which can also be built from a Transmission: the DeliveryRequest is then
    # made from the transmission's letter (see BuildDeliveryRequest). Each field of that request
    # is read only when it is first needed.
    class Arguments < Relay::GPConnect::FHIR::Arguments
      attr_reader :transmission

      def initialize( # rubocop:disable Metrics/ParameterLists
        transaction_uuid:,
        transmission: nil,
        request: nil,
        transmission_uuid: nil,
        organisation_uuid: nil,
        itk_organisation_uuid: nil
      )
        @transmission = transmission
        request ||= Letters::BuildDeliveryRequest.new(
          letter: transmission.letter,
          organisation_uuid:,
          itk_organisation_uuid:
        ).lazy
        super(request:, transaction_uuid:, transmission_uuid:)
      end

      def letter = transmission&.letter
      def transmission_uuid = super || transmission.uuid
    end
  end
end
