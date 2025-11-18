module Renalware
  module Patients
    module Ingestion
      #
      # Responsible for making commands to process messages based on the message type.
      #
      class CommandFactory
        def for(msg) # rubocop:disable Metrics/CyclomaticComplexity
          case msg.action
          when :add_person_information, :update_person_information then make_update_patient(msg)
          when :add_patient               then make_add_patient(msg)
          when :admit_patient             then make_admit_patient(msg)
          when :update_admission          then make_update_admission(msg)
          when :cancel_admission          then make_cancel_admission(msg)
          when :transfer_patient          then make_transfer_patient(msg)
          when :discharge_patient         then make_discharge_patient(msg)
          when :cancel_discharge          then make_cancel_discharge(msg)
          when :merge_patient             then make_merge_patient(msg)
          else noop
          end
        end

        private

        def make_add_patient(msg)       = Patients::Ingestion::Commands::AddPatient.new(msg)
        def make_update_patient(msg)    = Patients::Ingestion::Commands::UpdatePatient.new(msg)
        def make_admit_patient(msg)     = Admissions::Ingestion::Commands::AdmitPatient.new(msg)
        def make_update_admission(msg)  = Admissions::Ingestion::Commands::AdmitPatient.new(msg)
        def make_cancel_admission(msg)  = Admissions::Ingestion::Commands::CancelAdmission.new(msg)
        def make_transfer_patient(msg)  = Admissions::Ingestion::Commands::AdmitPatient.new(msg)
        def make_discharge_patient(msg) = Admissions::Ingestion::Commands::AdmitPatient.new(msg)
        def make_cancel_discharge(msg)  = Admissions::Ingestion::Commands::AdmitPatient.new(msg)
        def make_merge_patient(msg)     = Patients::Ingestion::Commands::MergePatient.new(msg)
        def noop                        = NullObject.instance
      end
    end
  end
end
