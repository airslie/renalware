module Renalware
  module Transplants
    # Form object to help us map chosen input values in the MDM patient list filters form
    # into ransack predicates.
    class MDMPatientsForm
      include ActiveModel::Model
      include Virtus::Model

      attribute :hospital_centre_id, Integer
      attribute :named_consultant_id, Integer
      attribute :named_nurse_id, Integer
      attribute :url

      # StrongParameter support. Called by a controller when whitelisting params.
      def self.permittable_attributes
        attribute_set.map(&:name)
      end

      # The hash returned here is passed into the Ransack #search method later in the query object.
      def ransacked_parameters
        {
          hospital_centre_id_eq: hospital_centre_id,
          named_nurse_id_eq: named_nurse_id,
          named_consultant_id_eq: named_consultant_id
        }
      end
    end
  end
end
