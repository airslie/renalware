module Renalware
  module Patients
    class AttachmentType < ApplicationRecord
      acts_as_paranoid
      validates :name, presence: true, uniqueness: true
      delegate :to_s, to: :name

      def store_file_internally?
        !store_file_externally
      end
    end
  end
end
