module Renalware
  module HD
    # Targets a Postgres view
    # TODO: Write tests inc the ordering of data (parent then child) in the view.
    class GroupedTransmissionLog < ApplicationRecord
      scope :for_uuid, ->(uuid) { where(uuid: uuid) }
      scope :incoming, -> { where(direction: :in) }
      scope :outgoing, -> { where(direction: :out) }
    end
  end
end
