module Renalware
  module Transplants
    module Registrations
      class WaitListForm
        include ActiveModel::Model
        include Virtus::Model

        attribute :ukt_recipient_number, String
      end
    end
  end
end
