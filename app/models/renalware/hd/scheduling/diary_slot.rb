# frozen_string_literal: true

module Renalware
  module HD
    module Scheduling
      class DiarySlot < ApplicationRecord
        self.table_name = :hd_diary_slots
        # Changing to_ary from private to public here is a hack required to remove a SimpleDelegator
        # warning in eg Renalware::HD::Scheduling::WeeklyDiary::WeeklySlotDecorator:
        #
        #   `respond_to?': delegator does not forward private method #to_ary
        #
        # Yielding a slot from DiaryPresenter to the view seems to want to call #to_ary on it, (have
        # not looked into why) and as the slot is wrapped in a decorator using SimpleDelegator,
        # SimpleDelegator complains it can't delegate to a private method.
        # An alternative is to define the following in each Slot decorator
        #
        #    def respond_to?(method, include_private = false)
        #      return false if method == :to_ary
        #      super
        #    end
        #
        #  or to use method_missing instead of SimpleDelegator in Slot Decorators.
        #
        public :to_ary

        # Virtual attribute used on a form to determine what action as preformed on the slot
        attr_accessor :patient_search_scope
        # Virtual to help the pre-population of select2 with the offending patient if an error
        attr_accessor :patient_ids

        include Accountable

        DAYS = %i(monday tuesday wednesday thursday friday saturday sunday).freeze

        belongs_to :diary, class_name: "Renalware::HD::Scheduling::Diary", touch: true
        belongs_to :patient, touch: true
        belongs_to :station, class_name: "Renalware::HD::Station"
        belongs_to :diurnal_period_code

        validates :diary, presence: true
        validates :patient, presence: true
        validates :station, presence: true
        validates :diurnal_period_code, presence: true
        validates :day_of_week, presence: true, inclusion: { in: 1..7 }

        scope :weekly, -> { joins(:diary).where(hd_diaries: { master: false }) }
        scope :archived, -> { weekly.where(archived: true) }
        scope :unarchived, -> { weekly.where(archived: false) }

        # A patient can only be assigned to one station in any period (e.g. am)/day combination
        # for a diary. I.e. they can't be on two stations on Monday morning.
        validates :patient_id,
                  uniqueness: { scope: [:diary, :diurnal_period_code, :day_of_week] }

        # Scoped to a diary, the combination of day + station + diurnal_period is unique
        validates :diurnal_period_code_id,
                  uniqueness: { scope: [:diary, :station_id, :day_of_week] }

        delegate :id, to: :diary, prefix: true

        def self.policy_class = DiaryPolicy

        def on_master_diary?
          diary&.master?
        end

        def description
          period = diurnal_period_code.code.upcase # e.g. AM
          if diary.master
            "Recurring every #{day_of_week_name} #{period}"
          else
            "This week only on #{day_of_week_name} #{period}"
          end
        end

        def day_of_week_name
          DAYS[day_of_week - 1].capitalize
        end

        def cell_id
          "#{diurnal_period_code&.id}-#{station&.id}-#{day_of_week}"
        end

        def to_s
          return "" unless patient

          "#{patient} #{formatted_arrival_time}".strip
        end

        private

        def formatted_arrival_time
          return unless arrival_time

          "(#{arrival_time.strftime('%H:%M')})"
        end
      end
    end
  end
end
