module Renalware
  module Help
    module Tours
      class Annotation < ApplicationRecord
        belongs_to :page
        validates :attached_to_selector,
                  presence: true,
                  uniqueness: { scope: :page_id }

        def to_json(_options = {})
          {
            id: id,
            title: title,
            text: text,
            attachTo: {
              element: attached_to_selector,
              on: attached_to_position
            }
          }
        end
      end
    end
  end
end
