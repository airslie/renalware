module Renalware
  module Medications
    # - If one of the attributes in NEW_PRESCRIPTION_ATTRS has changed then we terminate the old
    #   prescription and create a new one.
    # - If the dose has changed we attempt to re-assign a future termination date
    class RevisePrescription
      attr_reader :prescription, :params

      pattr_initialize :prescription, :current_user

      NEW_PRESCRIPTION_ATTRS = %w(
        dose_amount
        unit_of_measure_id
        frequency
        administer_on_hd
        stat
      ).freeze

      def call(params)
        prescription.assign_attributes(params)
        return false unless prescription.valid?

        if new_prescription_required?
          TerminateExistingAndCreateNewPrescription.new(
            prescription.reload,
            current_user,
            params
          ).call
        else
          if prescription.prescribed_on_changed?
            HD::AssignFuturePrescriptionTermination.call(
              prescription: prescription,
              by: current_user
            )
          end
          prescription.save
        end
      end

      private

      def new_prescription_required?
        attr_intersection = prescription.changed_attributes.keys & NEW_PRESCRIPTION_ATTRS
        attr_intersection.count > 0
      end
    end

    class TerminateExistingAndCreateNewPrescription
      attr_reader :prescription,
                  :current_user,
                  :params,
                  :prev_prescribed_on,
                  :prev_terminated_on

      def initialize(prescription, current_user, params)
        @prescription = prescription
        @current_user = current_user
        @params = params
        @prev_prescribed_on = prescription.prescribed_on
        @prev_terminated_on = prescription.termination&.terminated_on
      end

      def call
        Prescription.transaction do
          terminate_existing_prescription
          create_new_prescription
        end
      end

      private

      def terminate_existing_prescription
        if ENV.key?("CHANGE_FUTURE_PRESCRIBED_ON_TO_TODAY_WHEN_TERMINATING")
          update_prescription_dates_and_notes
          prescription.save!(validate: false)
        end

        # Now terminate the original prescription with a terminated_on of today
        prescription
          .terminate(by: params[:by], terminated_on: Date.current)
          .save!(validate: false)
      end

      # Call this only if we decide to terminate future prescriptions by changing
      # prescribed_on and terminated_on to today, including notes about what the original
      # values were.
      def update_prescription_dates_and_notes
        if prescription.prescribed_on > Time.zone.today
          prescription.prescribed_on = Time.zone.today
          prescription.notes += "Terminated due to a change. " \
                                "Was prescribed on #{prescription.prescribed_on}"
          if prescription.termination.present?
            prescription.notes += " and due to terminate on " \
                                  "#{prescription.termination.terminated_on}"
          end
        end
      end

      def create_new_prescription
        new_prescription = Prescription.new(terminated_prescription_attributes)
        new_prescription.assign_attributes(params)

        new_prescription.prescribed_on = if prev_prescribed_on > Time.zone.today
                                           prev_prescribed_on
                                         else
                                           Date.current
                                         end

        if prev_terminated_on
          new_prescription.build_termination(
            terminated_on: prev_terminated_on,
            by: current_user
          )
        end
        HD::AssignFuturePrescriptionTermination.call(
          prescription: new_prescription,
          by: current_user
        )
        new_prescription.save!
      end

      def terminated_prescription_attributes
        prescription.attributes.slice(*included_attributes)
      end

      # These are the attributes we copy across from old prescription to the new one before
      # terminating the old one. We overwrite these attributes with incoming values from @params,
      # so perhaps there is no benefit to this approach?
      def included_attributes
        %w(
          patient_id
          drug_id
          treatable_id
          treatable_type
          dose_amount
          medication_route_id
          route_description
          frequency
          prescribed_on
          notes
          provider
        )
      end

      def new_prescription_is_administer_on_hd?
        ActiveModel::Type::Boolean.new.cast(params[:administer_on_hd])
      end

      # For now we have a hard-coded ref to HD which we could remove using eg Wisper.
      def allow_other_domains_to_alter_prescription
        HD::AssignFuturePrescriptionTermination.call(
          prescription: new_prescription,
          by: current_user
        )
      end
    end
  end
end
