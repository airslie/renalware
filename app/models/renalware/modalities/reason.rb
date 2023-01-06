# frozen_string_literal: true

module Renalware
  module Modalities
    class Reason < ApplicationRecord
      def self.policy_class
        BasePolicy
      end
    end
  end
end
