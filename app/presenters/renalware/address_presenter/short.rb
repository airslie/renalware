module Renalware
  class AddressPresenter::Short < AddressPresenter
    private

    def presentable_attrs
      [street_1, postcode]
    end
  end
end
