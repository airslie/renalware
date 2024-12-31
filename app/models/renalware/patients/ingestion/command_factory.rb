module Renalware
  module Patients
    module Ingestion
      # Responsible for making commands to process messages based on the
      # message type.
      #
      class CommandFactory
        # Note that for now most of these mapped methods will only try and
        # update the patient info and master patient index, and not actually
        # try and create an admission/transfer etc. Patients only get added to RW in receipt of an
        # HL7 pathology AKI score or HL7 ADT (or SIU) appointment message.
        def for(message)
          case message.action
          when :add_person_information    then make_add_patient(message)
          when :update_person_information then make_update_patient(message)
          when :admit_patient             then make_admit_patient(message)
          when :update_admission          then make_update_admission(message)
          when :cancel_admission          then make_cancel_admission(message)
          when :transfer_patient          then make_transfer_patient(message)
          when :discharge_patient         then make_discharge_patient(message)
          when :cancel_discharge          then make_cancel_discharge(message)
          # when :merge_patient then make_merge_patient(message) # complex so ignore for now.
          # when :add_consultant then make_add_consultant(message)
          else noop
          end
        end

        private

        def make_add_patient(message)
          Commands::UpdatePatient.new(message)
        end

        def make_update_patient(message)
          Commands::UpdatePatient.new(message)
        end

        def noop
          NullObject.instance
        end

        def make_admit_patient(message)
          Commands::UpdatePatient.new(message)
          # Commands::AdmitPatient.new(message,
          #   patient_finder: make_patient_finder_with_add_if_missing)
        end

        def make_update_admission(message)
          Commands::UpdatePatient.new(message)
          # Commands::UpdateAdmission.new(message,
          #   admission_finder: make_admission_finder_with_logging_if_missing)
        end

        def make_cancel_admission(message)
          Commands::UpdatePatient.new(message)
          # Commands::CancelAdmission.new(message,
          #   admission_finder: make_admission_finder_with_logging_if_missing)
        end

        def make_transfer_patient(message)
          Commands::UpdatePatient.new(message)
          # Commands::TransferPatient.new(message,
          #   admission_finder: make_admission_finder_with_admit_if_missing)
        end

        def make_discharge_patient(message)
          Commands::UpdatePatient.new(message)
          # Commands::DischargePatient.new(message,
          #   admission_finder: make_admission_finder_with_logging_if_missing)
        end

        def make_cancel_discharge(message)
          Commands::UpdatePatient.new(message)
          # Commands::CancelDischarge.new(message)
        end

        # def make_add_consultant(message)
        #   Commands::AddConsultant.new(message)
        # end

        # def make_admission_finder_with_logging_if_missing
        #   MissingAdmissionLogger.new(make_admission_finder)
        # end

        # def make_admission_finder_with_admit_if_missing
        #   MissingRecordHandler.new(make_admission_finder,
        #     policy: make_missing_admission_handler)
        # end

        # def make_admission_finder
        #   Finder::Admission.new
        # end

        # def make_patient_finder_with_add_if_missing
        #   MissingRecordHandler.new(Finder::Patient.new,
        #     policy: make_missing_patient_handler)
        # end

        # def make_minor_patient_finder_with_add_if_missing
        #   missing_patient_handler = lambda { |message|
        #     Commands::AddPatient.new(
        #       message,
        #       mapper_factory: MessageMappers::MinorPatient
        #     ).call
        #   }

        #   MissingRecordHandler.new(Finder::MinorPatient.new,
        #     policy: missing_patient_handler)
        # end

        # def make_missing_patient_handler
        #   lambda { |message|
        #     make_add_patient(message).call
        #   }
        # end

        # def make_missing_admission_handler
        #   lambda { |message|
        #     make_admit_patient(message).call
        #   }
        # end
        #
        #
        # def make_add_patient_with_finder(message)
        #   CommandWithFinder.new(
        #     make_add_patient(message),
        #     message, finder: Finder::Patient.new
        #   )
        # end

        # def make_add_patient_with_finder(message)
        #   CommandWithFinder.new(
        #     make_add_patient(message),
        #     message, finder: Finder::Patient.new
        #   )
        # end
        #
        # def make_merge_patient(message)
        #   Commands::MergePatient.new(message,
        #     major_patient_finder: make_patient_finder_with_add_if_missing,
        #     minor_patient_finder: make_minor_patient_finder_with_add_if_missing)
        # end
      end
    end
  end
end
