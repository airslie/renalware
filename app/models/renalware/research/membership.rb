# frozen_string_literal: true

require_dependency "renalware/research"

module Renalware
  module Research
    class Membership < ApplicationRecord
      include Accountable
      belongs_to :user
      belongs_to :study
      belongs_to :hospital_centre, class_name: "Renalware::Hospitals::Centre"

      validates :user, presence: true
      validates :study, presence: true
      validates :hospital_centre, presence: true

      validates :user_id, uniqueness: { scope: :study_id }

      delegate :to_s, to: :user
    end
  end
end
