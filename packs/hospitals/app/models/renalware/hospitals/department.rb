# frozen_string_literal: true

module Renalware
  module Hospitals
    # E.g. Renal Dept
    class Department < ApplicationRecord
      acts_as_paranoid

      belongs_to :hospital_centre,
                 class_name: "Hospitals::Centre",
                 touch: true,
                 counter_cache: true

      has_one :address, as: :addressable, class_name: "Address", dependent: :destroy

      validates :hospital_centre, presence: true
      validates :name, presence: true

      accepts_nested_attributes_for :address

      scope :ordered, -> { order(:name) }

      def self.policy_class = BasePolicy
      def to_s = name
    end
  end
end
