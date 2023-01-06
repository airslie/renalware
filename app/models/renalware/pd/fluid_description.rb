# frozen_string_literal: true

module Renalware
  module PD
    class FluidDescription < ApplicationRecord
      has_many :peritonitis_episodes, dependent: :restrict_with_exception
    end
  end
end
