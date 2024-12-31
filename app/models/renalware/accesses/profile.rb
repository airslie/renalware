module Renalware
  module Accesses
    class Profile < ApplicationRecord
      include Accountable
      extend Enumerize

      belongs_to :patient, touch: true
      belongs_to :type, class_name: "Type"

      has_paper_trail(
        versions: { class_name: "Renalware::Accesses::Version" },
        on: %i(create update destroy)
      )

      scope :ordered, -> { order(formed_on: :desc) }
      scope :current, lambda {
        where(<<-SQL.squish, date: Time.zone.today)
          started_on <= :date AND
          (terminated_on IS NULL OR terminated_on > :date)
        SQL
      }
      scope :past_and_future, lambda {
        where(<<-SQL.squish, date: Time.zone.today)
          (started_on > :date OR started_on IS NULL) OR
          (terminated_on IS NOT NULL AND terminated_on <= :date)
        SQL
      }

      validates :type, presence: true
      validates :side, presence: true
      validates :formed_on, presence: true
      validates :formed_on, timeliness: { type: :date, allow_blank: false }
      validates :started_on, timeliness: { type: :date, allow_blank: true }
      validates :terminated_on, timeliness: { type: :date, allow_blank: true }

      enumerize :side, in: %i(left right)

      def self.policy_class = BasePolicy
    end
  end
end
