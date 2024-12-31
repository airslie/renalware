module Renalware
  module PD
    class Assessment < ApplicationRecord
      include Accountable
      include PatientScope
      include OrderedScope
      include Document::Base
      extend Enumerize

      belongs_to :patient, class_name: "Renalware::PD::Patient", touch: true

      attr_reader :ignore_me # see html form for explanation of this non-persistent attribute

      class Document < Document::Embedded
        attribute :assessed_on, Date
        attribute :assessor, String
        attribute :had_home_visit, ::Document::Enum, enums: %i(yes no)
        attribute :home_visit_on, Date
        attribute :housing_type, ::Document::Enum, enums: %i(flat house bungalow)
        attribute :occupant_notes
        attribute :exchange_area, String
        attribute :handwashing, String
        attribute :fluid_storage, String
        attribute :bag_warming, String
        attribute :delivery_interval, String
        attribute :needs_rehousing, ::Document::Enum, enums: %i(yes no)
        attribute :rehousing_notes
        attribute :social_worker, ::Document::Enum, enums: %i(yes no)
        attribute :seen_video, ::Document::Enum, enums: %i(yes no)
        attribute :can_open_bag, ::Document::Enum, enums: %i(yes no)
        attribute :can_lift_bag, ::Document::Enum, enums: %i(yes no)
        attribute :eyesight, String
        attribute :hearing, String
        attribute :dexterity, String
        attribute :motivation, String
        attribute :language, String
        attribute :other_notes
        attribute :suitable_for_pd, ::Document::Enum, enums: %i(yes no)
        attribute :system_choice, ::Document::Enum # Defined in i18n as may vary
        attribute :insertion_discussed, ::Document::Enum, enums: %i(yes no)
        attribute :method_chosen, ::Document::Enum # Defined in i18n as may vary
        attribute :access_clinic_referral, ::Document::Enum, enums: %i(yes no)
        attribute :access_clinic_on, Date
        attribute :abdo_assessor, String
        attribute :bowel_disease, ::Document::Enum, enums: %i(yes no)
        attribute :bowel_disease_notes
        attribute :added_comments

        validates :assessed_on, presence: true, timeliness: { type: :date }
        validates :home_visit_on, timeliness: { type: :date, allow_blank: true }
        validates :access_clinic_on, timeliness: { type: :date, allow_blank: true }
      end
      has_document
    end
  end
end
