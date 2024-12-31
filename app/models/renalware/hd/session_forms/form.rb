module Renalware
  module HD
    module SessionForms
      class Form
        include ActiveModel::Model
        include Virtus::Model

        attribute :patient_ids, String
      end
    end
  end
end
