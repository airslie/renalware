# frozen_string_literal: true

module Renalware
  module Clinics
    describe Ingestion::MessageListener do
      subject(:listener) { described_class.new }

      describe "#adt_message_arrived" do
        {
          schedule_new_appointment: Ingestion::Commands::CreateOrUpdateAppointment,
          cancel_appointment: Ingestion::Commands::DeleteAppointment
        }.each do |action, receiver|
          it "calls #{receiver} when HL7 message action is #{action}" do
            allow(receiver).to receive(:call)
            hl7_message = instance_double(Feeds::HL7Message, action: action, adt?: true)

            listener.adt_message_arrived(hl7_message: hl7_message, adt?: true)

            expect(receiver).to have_received(:call)
          end
        end
      end
    end
  end
end
