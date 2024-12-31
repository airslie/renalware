module Renalware
  module Modalities
    # A change type must be chosen when adding a new modality. It specifies the type of modality
    # change eg 'Transfer In', 'Transfer Out', 'HD to PD' etc. There will be an 'Other' option
    # where the change type is unknown or does not match any of the other options.
    class ChangeType < ApplicationRecord
      include Accountable
      acts_as_paranoid

      validates :name, presence: true, uniqueness: true
      validates :code, presence: true, uniqueness: true

      scope :ordered, -> { order(name: :asc) }

      class ChangeTypeWithDefaultFlagOrCodeOfOtherNotFound < StandardError; end

      def self.default
        find_by(default: true) || find_by!(code: "other")
      rescue ActiveRecord::RecordNotFound => _e
        raise ChangeTypeWithDefaultFlagOrCodeOfOtherNotFound
      end
    end
  end
end
