module Renalware
  module Hospitals
    class WardPresenter < SimpleDelegator
      def self.units_with_wards
        Hospitals::Unit.eager_load(:wards).merge(Hospitals::Ward.active)
      end

      def title
        code.blank? ? name : "#{name} (#{code})"
      end

      def title_including_unit
        "#{title} at #{hospital_unit.unit_code}"
      end
    end
  end
end
