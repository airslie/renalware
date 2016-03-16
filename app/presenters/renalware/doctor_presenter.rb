module Renalware
  class DoctorPresenter < SimpleDelegator
    def address_line
      current_address = address || practice_address
      current_address.to_s(:street_1, :street_2, :city, :county, :postcode, :country)
    end

    def practice_address
      practices.first.try(:address)
    end
  end
end