module Renalware
  module System
    class Download < ApplicationRecord
      include Accountable
      include RansackAll

      acts_as_paranoid
      validates :name, presence: true, uniqueness: true
      has_one_attached :file
      validates :file, presence: true
      validate :validate_presence_of_file_attachment

      private

      def validate_presence_of_file_attachment
        errors.add(:file, "Please specify a file to upload") unless file.attached?
      end
    end
  end
end
