module Renalware
  # A base class for Summary presenters in other name-spaces. SummaryParts can be composed into
  # reporting dashboards or summary pages. The Clinical Summary for instance comprises an array
  # of various SummaryParts
  class SummaryPart
    DATE_FORMAT = "%Y%m%d%H%M%S%L".freeze
    rattr_initialize :patient, :current_user
    attr_implement :to_partial_path

    # If the subclass defines a cache_key Rails will cache the partial
    def cache_key
      nil
    end

    def render?
      true
    end

    def cache?
      cache_key.present?
    end

    protected

    def date_formatted_for_cache(date)
      date&.strftime(DATE_FORMAT)
    end

    def title_friendly_collection_count(actual:, total:)
      if total > actual
        "#{actual} of #{total}"
      else
        actual
      end
    end
  end
end
