# frozen_string_literal: true

module Renalware
  module Drugs
    class Supplier < ApplicationRecord
      validates :name, presence: true
    end
  end
end
