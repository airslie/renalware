# frozen_string_literal: true

require_dependency "renalware/hd"

module Renalware
  module HD
    # An HD::Provider is a company managing dialysers for example Diaverum or Fresenius
    class Provider < ApplicationRecord
      validates :name, presence: true
    end
  end
end
