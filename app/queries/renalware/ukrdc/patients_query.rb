module Renalware
  module UKRDC
    # If the optional :changed_since argument is passed we select all PKB
    # patients how have been updated since that date. Otherwise we select all PKB
    # patients who have changed since the last time they were exported.
    # A patient has a sent_to_ukrdc_at datetime which is the last time the data was actually sent.
    # It maybe be that something about the patient has changed and updated_at > sent_to_ukrdc_at
    # however when compiled to xml there are no effective changes, for example because some notes
    # were added somewhere on the patient's data but those notes don't make it into the XML. So
    # therefore no effective changes and we don't send the file to UKRDC.
    # However a downside of this approach is that we always find updated patients and generate
    # an XML for them, in order to compare an MD5 hash of the XML with what was previously sent, and
    # *sometimes* this is waste of time if the MD5 hash has not changed. However we will live with
    # this for now I think. If it is a problem we can use the checked_for_ukrdc_changes_at column
    # on patients.
    class PatientsQuery
      def call(changed_since: nil, changed_since_last_send: true)
        if changed_since.present?
          # patients who changed since a specific date (inclusive)
          sendable_patients.where(updated_at: changed_since..)
        elsif changed_since_last_send
          # patients who have never been sent, or have changed since the last time they were sent
          sendable_patients.where("(sent_to_ukrdc_at is null) or (updated_at > sent_to_ukrdc_at)")
        else
          sendable_patients
        end
      end

      private

      def sendable_patients
        Renalware::Patient.where(send_to__where_sql).order(family_name: :asc, given_name: :asc)
      end

      def send_to__where_sql
        where = []
        where << "send_to_rpv = true" if Renalware.config.ukrdc_send_rpv_patients
        where << "send_to_renalreg = true" if Renalware.config.ukrdc_send_rreg_patients

        if where.empty?
          raise ArgumentError, "#{self.class.name}.sendable_patients would send all patients!"
        end

        where.join(" or ")
      end
    end
  end
end
