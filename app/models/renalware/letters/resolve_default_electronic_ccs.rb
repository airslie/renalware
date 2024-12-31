module Renalware
  module Letters
    # This class is responsible for collating the complete set of default electronic ccs for a new
    # patient letter.
    # An HD patient for instance might have a named nurse who should always be eCCed into any
    # letters about them.
    # Important to note here is that we are of course in the Letters module and have no knowledge
    # of who should be eCCs and how to resolve those users; these are matters that relate for
    # example to the user's current modality and the corresponding module (HD, PD, Transplant etc).
    # So here all we can do is broadcast a (synchronous) event asking anyone listening (ie any
    # class that is configured to listen in the broadcast_map) to add their eCC users to the
    # passed in array_of_user_ids array. We will then de-dupe and return that array,
    # where it will be used to initialize the eCC component on the letters UI form with the correct
    # initial default set up eCC users. This only applies to new letters, ie when displaying the
    # the UI form for a new letter.
    #
    # Example usage:
    #
    #   array_of_ecc_users = ResolveDefaultElectronicCCs
    #     .for(patient)
    #     .broadcasting_to_configured_subscribers
    #     .call
    #
    class ResolveDefaultElectronicCCs
      include Broadcasting
      pattr_initialize :patient

      def self.for(patient)
        new(patient)
      end

      def call
        array_of_user_ids = []
        broadcast(
          :request_default_electronic_cc_recipients_for_use_in_letters,
          patient: patient,
          array_of_user_ids: array_of_user_ids
        )
        array_of_user_ids.compact.uniq
      end
    end
  end
end
