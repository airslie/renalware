module Renalware
  class AddressPresenter < DumbDelegator
    def to_s
      return "" if __getobj__.blank?

      presentable_attrs
        .map(&:to_s)
        .compact_blank
        .join(join_arg)
    end

    def country
      CountryPresenter.new(super)
    end

    def to_a
      return [] if __getobj__.blank?

      presentable_attrs
        .map(&:to_s)
        .compact_blank
    end

    private

    def join_arg
      ", "
    end

    def presentable_attrs
      [
        name,
        organisation_name,
        street_1,
        street_2,
        street_3,
        town,
        county,
        postcode,
        country
      ]
    end
  end
end
