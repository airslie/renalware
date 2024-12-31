module Renalware
  module Pathology
    # We maintain current observations for each patient in their #current_observation_set.
    # CurrentObservationSet#values is a hash (stored as jsonb) where the OBX code
    # is the key and the result value and observation date are themselves a hash.
    # So values looks like this
    # {
    #   "HGB": {
    #     "result": 123,
    #     observed_at: "2017-12-12 12:12:12"
    #   },
    #   "CRE": {
    #     ...
    #   }
    # }
    # and *always* contains the very latest pathology result for any code.
    # We store all incoming OBX codes, not just a restricted list.
    # Legacy data might only contain a subset of codes, so #values should not be relied on
    # to cover current observations for the patients entire history, just key ones.
    # When displaying or using a patient's current_observation_set the consuming code
    # must filter out the codes it wants.
    class CurrentObservationSet < ApplicationRecord
      belongs_to :patient,
                 class_name: "Renalware::Pathology::Patient",
                 inverse_of: :current_observation_set
      validates :patient, presence: true
      serialize :values, coder: ObservationsJsonbSerializer

      def self.null_values_hash
        ActiveSupport::HashWithIndifferentAccess.new.extend(ObservationSetMethods)
      end

      # Select values frm the set where the code matches the code or array of codes
      # requested.
      # When the code is not found in the set, return an empty hash for that code.
      # When the patient has no current_observation_set, return an empty hash for each code.
      # We need to be sure to extend the HashWithIndifferentAccess returned from
      # #select with the ObservationSetMethods so a user can call eg {..}.hgb_date
      # or {..}.plt etc without error
      def values_for_codes(codes)
        hash = Array(codes)
          .each_with_object(ActiveSupport::HashWithIndifferentAccess.new) do |code, hash|
          hash[code] = values[code] || CurrentObservationSet.null_values_hash
        end
        hash.extend(ObservationSetMethods)
      end
    end
  end
end
