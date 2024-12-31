module Renalware
  module Patients
    module Ingestion
      describe CommandFactory do
        subject(:factory) { described_class.new }

        def message_returning_action(action)
          instance_double(Renalware::Feeds::HL7Message, action: action)
        end

        # For the moment all ADT messages do is update the patient's details if they exist in RW,
        # or update the master patient index.
        describe "#for" do
          {
            update_person_information: Commands::UpdatePatient,
            add_person_information: Commands::UpdatePatient,
            discharge_patient: Commands::UpdatePatient,
            admit_patient: Commands::UpdatePatient,
            update_admission: Commands::UpdatePatient,
            cancel_admission: Commands::UpdatePatient,
            transfer_patient: Commands::UpdatePatient,
            cancel_discharge: Commands::UpdatePatient
          }.each do |message_type, command_class|
            context "when a #{message_type} message type" do
              subject { factory.for(message_returning_action(message_type)) }

              it { is_expected.to be_a(command_class) }
            end
          end

          context "when a :merge_patient message type" do
            it "returns a new MergePatient command" do
              pending
              expect(
                factory.for(message_returning_action(:merge_patient))
              ).to be_a(Commands::MergePatient)
            end
          end

          context "when a :no_matching_command message type" do
            it "returns a null object" do
              expect(
                factory.for(message_returning_action(:no_matching_command))
              ).to be_a(NullObject)
            end
          end
        end
      end
    end
  end
end
