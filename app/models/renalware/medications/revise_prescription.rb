# frozen_string_literal: true

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
      pattr_initialize :prescription, :current_user, :params

      def call
        Prescription.transaction do
          terminate_existing_prescription
          create_new_prescription
        end
      end

      private

      # If we are terminating a give_on_hd prescription then always force terminate it
      def terminate_existing_prescription
        return if prescription.termination.present? && !new_prescription_is_administer_on_hd?

        prescription.terminate(by: params[:by]).save!
      end

      def create_new_prescription
        new_prescription = Prescription.new(terminated_prescription_attributes)
        new_prescription.assign_attributes(params)
        new_prescription.prescribed_on = Date.current
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
