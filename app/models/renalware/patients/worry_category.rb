# frozen_string_literal: true

module Renalware
  module Patients
    class WorryCategory < ApplicationRecord
      include Accountable
      acts_as_paranoid
      validates :name, presence: true, uniqueness: true
    end
  end
end
