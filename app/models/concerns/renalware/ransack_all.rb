module Renalware
  module RansackAll
    extend ActiveSupport::Concern

    class_methods do
      def ransackable_attributes(_auth_object = nil)
        column_names - %w(password password_confirmation)
      end

      def ransackable_associations(_auth_object = nil)
        reflect_on_all_associations.map { |a| a.name.to_s } + _ransackers.keys
      end
    end
  end
end
