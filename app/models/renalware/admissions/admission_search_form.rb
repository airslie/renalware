module Renalware
  module Admissions
    # Rather than using a Ransack Search object behind the form, as we do in many other places
    # here we use a custom form object. This is mainly because we have a drop down of (virtual)
    # statues, where each maps to a scope on Admission, where we want the selected 'status'
    # to result in its associated scope being called. Ransack doesn't handle this, not
    # surprisingly. So we have this thin form object around Ransack and do some pre-processing
    # on the Status attribute (see #status_scope).
    class AdmissionSearchForm
      include ActiveModel::Model
      include Virtus::Model

      attribute :hospital_unit_id, Integer
      attribute :hospital_ward_id, Integer
      attribute :status, String
      attribute :term, String

      # Pass our simple form attributes to Ransack - we lean on Ransack to do querying
      # so as to avoid unnecessary code here, though the magic obfuscates things a little...
      def submit
        @search ||= begin
          options = {
            hospital_ward_hospital_unit_id_eq: hospital_unit_id,
            hospital_ward_id_eq: hospital_ward_id,
            identity_match: term
          }.merge!(status_scope)

          AdmissionQuery.call(options)
        end
      end

      def status_dropdown_options
        [
          ["Currently admitted", :currently_admitted],
          ["Discharged but missing summary", :discharged_but_missing_a_summary]
        ]
      end

      # If a status was selected in the drop down, map this to a ransack way of saying
      # "call this scope on Admission", which is to pass the following (note the true
      # which indicates the scope should be used):
      #
      #   { name_of_scope: true }
      #
      def status_scope
        return {} if status.blank?

        { status.to_sym => true }
      end
    end
  end
end
