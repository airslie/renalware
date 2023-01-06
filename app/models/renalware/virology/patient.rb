# frozen_string_literal: true

module Renalware
  module Virology
    class Patient < ActiveType::Record[Renalware::Patient]
      has_one :profile, dependent: :destroy
    end
  end
end
