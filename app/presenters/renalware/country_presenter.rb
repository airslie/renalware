module Renalware
  class CountryPresenter < SimpleDelegator
    def to_s
      no_country_if_uk(super)
    end

    private

    def no_country_if_uk(country)
      ["UK", "United Kingdom"].include?(country) ? "" : country
    end
  end
end
