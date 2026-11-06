module Renalware
  module Letters
    module Delivery
      # The single answer to "should the GP's copy of this letter be sent electronically
      # (rather than printed)?". Used when a letter is approved (to set gp_send_status) and when
      # queueing the delivery, so the two can never disagree.
      class PrimaryCareDeliveryPolicy
        pattr_initialize :letter
        delegate :patient, to: :letter

        def send_electronically?
          return false unless GPLetterDelivery.electronic?
          return false if patient.confidentiality_restricted?
          return false unless letter.gp_is_a_recipient?

          true
        end
      end
    end
  end
end
