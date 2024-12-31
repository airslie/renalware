module Renalware
  module HD
    # An HD::Provider is a company managing dialysers for example Diaverum or Fresenius
    class ProviderUnit < ApplicationRecord
      belongs_to :hd_provider, class_name: "HD::Provider"
      belongs_to :hospital_unit, class_name: "Hospitals::Unit"
      validates :hd_provider, presence: true
      validates :hospital_unit, presence: true
    end
  end
end
