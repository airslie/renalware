module Renalware
  module Letters
    module Transports
      module Mesh
        class OperationPolicy < BasePolicy
          alias check_inbox? create?
          alias handshake? create?
        end
      end
    end
  end
end
