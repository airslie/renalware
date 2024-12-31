module Renalware
  module Modalities
    class DescriptionPresenter
      def self.list_for_dropdown
        Description.where(hidden: false).map do |desc|
          [
            desc.name,
            desc.id,
            {
              data: {
                code: desc.code
              }
            }
          ]
        end
      end
    end
  end
end
