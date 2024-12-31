module Renalware
  module Letters
    # Responsible for generating the IDENT metadata inserted at the top of emails to a practice
    # when a letter is attached. The IDENT data is parsed at the practice and used to file the
    # letter appropriately.
    # The IDENT specification (all on one line):
    #   <IDENT>PracticeIdent|LastName|FirstName|ID|NHS|DOB|KINGS COLLEGE HOSPITAL|
    #   LetterCreator|VisitDate|LetterName|LetterID|OriginatingUser|
    #   Created Date|GPIdent|CareGroup|LetterFrom</IDENT>
    # e.g.
    #   <IDENT>999999|Rabbit|Roger|X909090|2435465768|05/06/1978|
    #   KINGS COLLEGE HOSPITAL|Renalware|16/11/2017|Advice letter|
    #   437206|Jones, John|16/11/2017|G000000|RenalCareGroup|John Jones</IDENT>
    #
    class PracticeEmailMetaData
      NullPrimaryCarePhysician = Naught.build(&:define_explicit_conversions)
      NullPractice = Naught.build(&:define_explicit_conversions)

      pattr_initialize [
        :letter!,
        :primary_care_physician!,
        :practice!,
        :hospital_name,
        :letter_system_name,
        :care_group_name
      ]
      delegate :config, to: :Renalware
      delegate :patient, :author, to: :letter
      delegate :id, :description, :event, to: :letter, prefix: true
      delegate :hospital_name,
               :letter_system_name,
               :letter_default_care_group_name,
               to: :config, prefix: true

      def to_s
        "<IDENT>#{parts.join('|')}</IDENT>"
      end

      private

      # rubocop:disable Metrics/AbcSize
      def parts
        [
          practice.code,
          patient.family_name,
          patient.given_name,
          patient.local_patient_id,
          patient.nhs_number,
          format_date(patient.born_on),
          hospital_name || config_hospital_name,
          letter_system_name || config_letter_system_name,
          visit_or_letter_date,
          letter_description,
          letter_id,
          author,
          letter_date,
          primary_care_physician.code,
          care_group_name || config_letter_default_care_group_name,
          author.signature
        ]
      end
      # rubocop:enable Metrics/AbcSize

      def letter_date
        format_date(letter.date)
      end

      def format_date(date)
        date&.strftime("%d/%m/%Y")
      end

      def visit_or_letter_date
        date = letter_event&.send(:date) || letter.date
        format_date(date)
      end

      # We allow a missing primary_care_physician as not all patient's have one.
      def primary_care_physician
        @primary_care_physician ||= NullPrimaryCarePhysician.new
      end

      def practice
        @practice ||= NullPractice.new
      end
    end
  end
end
