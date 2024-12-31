# This class is responsible for transforming the attributes
# of a recipient. The resulting attributes can then
# be mass assigned to an ActiveRecord recipient object.
module Renalware
  module Letters
    class RecipientParamsProcessor
      def initialize(patient)
        @patient = patient
      end

      def call(params)
        params =
          if can_have_contact_as_addressee?(params)
            params = put_contact_as_addressee(params)
            translate_keep_flag_to_nested_attributes_destroy_flag(params)
          else
            clear_addressee(params)
          end

        remove_addressee_id(params)
      end

      private

      def can_have_contact_as_addressee?(params)
        params[:person_role] == "contact"
      end

      def put_contact_as_addressee(params)
        params.merge(addressee: fetch_contact(params))
      end

      def remove_addressee_id(params)
        params.except(:addressee_id)
      end

      def clear_addressee(params)
        params.merge(addressee: nil)
      end

      def translate_keep_flag_to_nested_attributes_destroy_flag(params)
        # ActiveRecord checks "_destroy" attribute to delete an existing
        # record when mass assigning nested attributes.
        # In our form, we need to use to "check" the contacts to be
        # assigned as CC's (not to destroy them).  So we therefore convert
        # the "_keep" flag to a "_destroy" one.
        params[:_destroy] = params[:_keep] == "1" ? "0" : "1"
        params.except(:_keep)
      end

      def fetch_contact(params)
        return if params[:addressee_id].blank?

        @patient.contacts.find(params[:addressee_id])
      end
    end
  end
end
