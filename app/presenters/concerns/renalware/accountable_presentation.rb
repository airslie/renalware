module Renalware
  # Helper methods to mix in to a Presenter class when displaying objects which include
  # the Accountable module - ie they have updated_by/at properties.
  module AccountablePresentation
    extend ActiveSupport::Concern

    def effective_updated_by
      return unless been_updated?

      updated_by&.full_name
    end

    def effective_updated_at_date
      return unless been_updated?

      updated_at&.to_date
    end

    def effective_updated_at
      return unless been_updated?

      updated_at
    end

    def been_updated?
      updated_at > created_at
    end
  end
end
