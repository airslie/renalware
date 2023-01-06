# frozen_string_literal: true

module Renalware
  module Transplants
    class RecipientWorkupPolicy < BasePolicy
      def new?
        super && record.new_record?
      end
    end
  end
end
