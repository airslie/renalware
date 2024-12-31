module World
  module HD::Protocol
    module Domain
      attr_reader :protocol

      def view_protocol(patient)
        view_context = nil
        @protocol = Renalware::HD::ProtocolPresenter.new(patient, view_context)
      end

      def expect_protocol_to_be(hashes)
        # check protocol presenter has things that are in the table?
        # expect(protocol).to be_present
        # expect(protocol.sessions).to be_present
      end
    end
  end
end
