module Renalware
  module HD
    module SessionForms
      class BatchPolicy < BasePolicy
        def status? = show?
      end
    end
  end
end
