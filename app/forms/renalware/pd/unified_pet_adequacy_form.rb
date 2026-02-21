# Captures data used for PET (Peritoneal Equilibration Test) and Adequacy.
module Renalware
  module PD
    class UnifiedPETAdequacyForm
      include ActiveModel::Model
      include Virtus::Model

      attribute :pet, PETResult
      attribute :adequacy, AdequacyResult
      attribute :patient, Patient

      attribute :pet_missing, Boolean
      attribute :adequacy_missing, Boolean

      # This method lets us just use eg simple_form_for in the view without
      # having to specify the url option i.e. PatientPDUnifiedPetAdequacy here will
      # resolve to 'patient_pd_pet_adequacy_results_path'
      def self.model_name
        ActiveModel::Name.new(self, nil, "PatientPDUnifiedPetAdequacy")
      end

      def valid?
        objects_to_save.each(&:validate).all?(&:valid?)
      end

      def save_by!(user)
        PETResult.transaction do
          objects_to_save.each { |obj| obj.save_by!(user) }
        end
      end

      def objects_to_save
        @objects_to_save ||= begin
          [].tap do |arr|
            arr << pet unless pet_missing
            arr << adequacy unless adequacy_missing
          end
        end
      end
    end
  end
end
