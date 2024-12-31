module Renalware
  module Letters
    # Build a new draft letter.
    # Used e.g from:
    # - LettersController#new - when building the initial letter form
    #   (in which case params are those supplied in #new)
    # - LettersController#create via DraftLetter.build - before saving the letter, in which case
    #   params is the posted hash of letter attributes from the html form.
    # TODO: think about spitting this into 2 classes, one for build (new/get) and one for creating
    # (create/post)?
    class LetterFactory
      def initialize(patient, params = {})
        @params = LetterParamsProcessor.new(patient).call(params)
        @patient = Letters.cast_patient(patient)
        @default_ccs = []
      end

      def build
        # *Important this line is here and not in initialize. If moved to initialize we will get
        # two copies of eCCs because of the way .with_contacts_as_default_ccs can be called
        # before .build
        @electronic_cc_recipient_ids = params.delete(:electronic_cc_recipient_ids) # see *

        @letter = build_letter
        build_electronic_ccs
        include_primary_care_physician_as_default_main_recipient
        assign_default_ccs
        build_salutation
        letter.pathology_timestamp = Time.zone.now
        stub_letter_electronic_cc_recipient_ids_using_patients_default_eccs
        include_default_qr_codes
        letter
      end

      def with_contacts_as_default_ccs
        @default_ccs = contacts_with_default_cc_option

        self
      end

      private

      attr_reader :patient, :letter, :params, :electronic_cc_recipient_ids

      def build_letter
        # We should not have to set the STI type manually here but in some circumstances
        # the type is not getting set by rails STI mechanism automatically - hence this hack.
        # TODO: Get to the bottom of why this is happening by removing the type setting and
        # running all cucumber specs to assess the errors.
        Letter::Draft.new(params.merge!(type: Letter::Draft.name, patient: patient))
      end

      # NOTE: both practice and gp need to be present before we can send to the pcp - we'll use the
      # practice address but the GP's name as the salutation.
      def include_primary_care_physician_as_default_main_recipient
        return if letter.main_recipient.present?

        if patient.primary_care_physician.present? && patient.practice_id.present?
          letter.build_main_recipient(person_role: :primary_care_physician)
        else
          letter.build_main_recipient(person_role: :patient)
        end
      end

      def contacts_with_default_cc_option
        patient.contacts.default_ccs
      end

      # Deal with wiring up new electronic CCs in the new, unsaved letter.
      # NB: The way electronic CCs are handled on building a new Letter and on updating an existing
      # one is different: when updating an existing letter (see code elsewhere) we lean on rails
      # doing some magic for us; as long as we have an array of electronic_cc_recipients in the
      # params, it will add/remove an associated electronic_receipt object for us (assigning the
      # letter_id to them in the process), because we used
      #   has_many :electronic_cc_recipients, through: :electronic_receipts
      # However, here, as we have no letter.id (letter is unsaved), Rails cannot yet create the
      # implied electronic_receipt object for each electronic_cc_recipient for us - we must do it
      # ourselves using electronic_receipts.build so rails will update the letter id in each when
      # the parent letter is saved.
      def build_electronic_ccs
        return if electronic_cc_recipient_ids.blank?

        electronic_cc_recipient_ids.compact_blank.map do |user_id|
          letter.electronic_receipts.build(recipient_id: user_id)
        end
      end

      # Here we are doing two things:
      #
      # 1 We overwrite the ActiveRecord-generated 'electronic_cc_recipient_ids' property that would,
      #   if any electronic_cc_recipients where saved against the letter, return the ids of those
      #   recipients. This property is used in the letter form when displaying the selected eCC
      #   users in a multi-select list. It works as expected when editing
      #   letters that have a saved set of eCC recipients. But for the case when we are creating a
      #   new letter, where there are no saved eCC recipients BUT we want to *pre-select* zero or
      #   more default eCCs, overwriting this property lets us spoof what AR would have done but
      #   instead of returning user ids resolved through the AR relationship (which would require
      #   those records to be saved) we return our own array. More on this next...
      #
      # 2 Inside our replacement #electronic_cc_recipient_ids property we resolve (collate, gather)
      #   the complete set of default eCC users (as an array of user ids) and return them.
      #   This lets us pre-select the default eCCs in the eCC multi-select
      #   UI component in the new letter form. The array of user ids is resolved by raising an
      #   event and asking any listeners to add in their eCC suggestions.
      #   See ResolveDefaultElectronicCCs for details.
      def stub_letter_electronic_cc_recipient_ids_using_patients_default_eccs
        return unless building_new_letter?

        letter.define_singleton_method(:electronic_cc_recipient_ids) do
          ResolveDefaultElectronicCCs
            .for(patient)
            .broadcasting_to_configured_subscribers
            .call
        end
      end

      def include_default_qr_codes
        if building_new_letter?
          letter.online_reference_links << System::OnlineReferenceLink.default_in_new_letters
        end
      end

      # We operate in two modes:
      # 1. building a skeleton letter (with defaults) to display in new letter form
      # 2. building the letter after an http post (ie in the controller create action in which case
      #    params will be fully populated.
      # This helper method resolves which mode we are in.
      # As letterhead_id is never passed when building a letter ready for display in the new form,
      # we assume that if it is present it is because it is in the posted html form params ie
      # we are going to go on and save the letter once built.
      def building_letter_ready_to_save?
        params.key?(:letterhead_id)
      end

      def building_new_letter?
        !building_letter_ready_to_save?
      end

      def build_salutation
        letter.salutation ||= begin
          main_recipient = letter.main_recipient
          if main_recipient.patient?
            patient.salutation
          elsif main_recipient.primary_care_physician?
            patient.primary_care_physician.salutation
          end
        end
      end

      def assign_default_ccs
        return if @default_ccs.empty?

        @default_ccs.each do |contact|
          letter.cc_recipients.build(person_role: "contact", addressee: contact)
        end
      end
    end
  end
end
