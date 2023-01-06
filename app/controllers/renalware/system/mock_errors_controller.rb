# frozen_string_literal: true

module Renalware
  module System
    class MockErrorsController < BaseController
      def index
        0 / 0 # ZeroDivisionError
      end
    end
  end
end
