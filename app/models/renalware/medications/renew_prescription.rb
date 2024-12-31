module Renalware
  module Medications
    class RenewPrescription
      include Callable
      pattr_initialize [:prescription!, :auto_terminate_after!, :by!]

      def call
        check_prescription
        Prescription.transaction do
          terminate_existing_prescription
          create_new_prescription
        end
      end

      private

      def check_prescription
        raise(ArgumentError, "prescription missing") if prescription.nil?
        raise(ArgumentError, "auto_terminate_after missing") if auto_terminate_after.nil?
        raise(ArgumentError, "by missing") if by.nil?
        unless prescription.administer_on_hd?
          raise(ArgumentError, "Prescription must be administer_on_hd=true")
        end
      end

      # Always skip validation as there is nowhere in the UI to show this error and
      # it leads to a 500 error. We need to be be careful with dates.
      def terminate_existing_prescription
        prescription.terminate(by: by).save!(validate: false)
      end

      def create_new_prescription
        new_prescription = Prescription.new(copyable_attributes)
        new_prescription.by = by
        new_prescription.prescribed_on = Date.current
        HD::AssignFuturePrescriptionTermination.call(
          prescription: new_prescription,
          by: by
        )
        new_prescription.save!
      end

      def copyable_attributes
        prescription.attributes.except(*attributes_to_exclude)
      end

      def attributes_to_exclude
        %w(
          id
          prescribed_on
          created_at
          updated_at
          created_by_id
          updated_by_id
        )
      end
    end
  end
end
