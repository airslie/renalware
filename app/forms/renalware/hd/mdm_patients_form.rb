module Renalware
  module HD
    # Form object to help us map chosen input values in the HD MDM patient list filters form
    # into ransack predicates. Used in this instance because mapping the form's
    # schedule_definition_ids dropdown value in the format of e.g "[1, 3, 6]" into the
    # integer array [1, 3, 6] is not something Ransack can do - hence this intermediate form object
    # to do the mapping.
    class MDMPatientsForm
      include ActiveModel::Model
      include Virtus::Model

      attribute :hospital_centre_id, Integer
      attribute :hospital_unit_id, Integer
      attribute :named_nurse_id, Integer
      attribute :named_consultant_id, Integer
      attribute :schedule_definition_ids, String # an Integer array in string form e.g. "[1 ,2]"
      attribute :url

      # StrongParameter support. Called by a controller when whitelisting params.
      def self.permittable_attributes
        attribute_set.map(&:name)
      end

      # The hash returned here is passed into the Ransack #search method later i the query object.
      def ransacked_parameters
        {
          hospital_centre_id_eq: hospital_centre_id,
          hd_profile_hospital_unit_id_eq: hospital_unit_id,
          hd_profile_schedule_definition_id_in: schedule_definition_ids_array,
          named_nurse_id_eq: named_nurse_id,
          named_consultant_id_eq: named_consultant_id
        }
      end

      private

      # Convert e.g. "[1,2,3]" to [1,2,3]
      def schedule_definition_ids_array
        return if schedule_definition_ids.blank?

        schedule_definition_ids.scan(/\d+/).map(&:to_i)
      end
    end
  end
end
