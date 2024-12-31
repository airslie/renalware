module Renalware
  module Events
    class Subtype < ApplicationRecord
      self.table_name = "event_subtypes"
      include Accountable
      include Supersedeable
      validates :name, presence: true, uniqueness: { scope: :event_type_id }
      validates :definition, presence: true
      validates :event_type_id, presence: true
      belongs_to :event_type, class_name: "Events::Type"

      has_paper_trail(
        versions: { class_name: "Renalware::Events::Version" },
        on: [:create, :update, :destroy]
      )

      # virtual for use in forms
      attr_accessor :fields
    end
  end
end
