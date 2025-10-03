# frozen_string_literal: true

module Renalware
  # Move into packs once Heroic integration is complete
  class Heroic::Events::HeroicEventDetail < Detail
    def view_template
      super do
        document.attributes.each_key do |attr_name|
          DetailItem(document, attr_name)
        end
        DetailItem(record, :notes)
      end
    end
  end
end
