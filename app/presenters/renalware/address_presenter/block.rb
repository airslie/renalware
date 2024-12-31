module Renalware
  class AddressPresenter::Block < AddressPresenter
    def to_html
      to_s.html_safe
    end

    private

    def join_arg
      "<br/>"
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
