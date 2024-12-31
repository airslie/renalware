module Renalware
  module Virology
    class Patient < Renalware::Patient
      has_one :profile, dependent: :destroy

      def self.model_name = ActiveModel::Name.new(self, nil, "Patient")
    end
  end
end
