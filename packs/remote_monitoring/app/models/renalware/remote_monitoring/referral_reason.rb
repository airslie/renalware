# frozen_string_literal: true

module Renalware
  module RemoteMonitoring
    class ReferralReason < ApplicationRecord
      acts_as_paranoid
      validates :description, presence: true, uniqueness: true
      scope :ordered, -> { order(position: :asc, description: :asc) }
    end
  end
end
