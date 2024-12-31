module Renalware
  module Patients
    class PracticesController < BaseController
      # Search for GP Practices matching part of a name
      def search
        authorize Practice, :search?
        respond_to do |format|
          format.json do
            render json: practices_matching_search_term
          end
        end
      end

      private

      def practices_matching_search_term
        PracticeSearchQuery.new(search_term: params[:q])
          .call
          .map { |practice| format_practice_into_hash_for_json(practice) }
      end

      def null_address
        Address.new
      end

      def format_practice_into_hash_for_json(practice)
        address = practice.address || null_address
        {
          id: practice.id,
          name: "#{practice.name} (#{practice.code})",
          address: [
            address.street_1,
            address.town,
            address.county,
            address.postcode
          ].compact_blank.join(", ")
        }
      end
    end
  end
end
