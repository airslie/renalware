# frozen_string_literal: true

require_dependency "renalware/admissions"

module Renalware
  module Admissions
    class Request < ApplicationRecord
      include Accountable
      extend Enumerize

      acts_as_paranoid

      belongs_to :patient, touch: true
      belongs_to :reason, class_name: "RequestReason"

      validates :patient_id, presence: true, uniqueness: true
      validates :reason_id, presence: true
      validates :priority, presence: true

      enumerize :priority, in: %i(low medium high urgent)

      scope :ordered, ->{ order(position: :asc) }
    end
  end
end
