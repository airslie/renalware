# frozen_string_literal: true

module Renalware
  class PrimaryCarePhysicianPresenter < SimpleDelegator
    def address
      AddressPresenter.new(current_address)
    end
  end
end
