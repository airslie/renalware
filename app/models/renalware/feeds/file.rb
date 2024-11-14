# frozen_string_literal: true

module Renalware
  module Feeds
    class File < ApplicationRecord
      include Accountable
      extend Enumerize

      validates :location, presence: true
      validates :status, presence: true
      validates :created_by, presence: true
      validates :file_type, presence: true

      belongs_to :file_type

      enum :status, { waiting: 0, processing: 1, success: 2, failure: 3 }

      scope :ordered, -> { order(created_at: :desc) }

      def self.build(location:, file_type:, user: SystemUser.find)
        new(
          location: location,
          file_type: file_type,
          status: :waiting,
          updated_by: user,
          created_by: user
        )
      end
    end
  end
end
