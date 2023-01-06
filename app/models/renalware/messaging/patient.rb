# frozen_string_literal: true

module Renalware
  module Messaging
    class Patient < ActiveType::Record[Renalware::Patient]
      has_many :messages, dependent: :restrict_with_exception

      def to_s(format = :long)
        super(format)
      end
    end
  end
end
