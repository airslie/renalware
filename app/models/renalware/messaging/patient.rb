module Renalware
  module Messaging
    class Patient < Renalware::Patient
      has_many :messages, dependent: :restrict_with_exception

      def self.model_name = ActiveModel::Name.new(self, nil, "Patient")

      def to_s(format = :long)
        super
      end
    end
  end
end
