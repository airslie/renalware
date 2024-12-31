module Renalware
  module Modalities
    class ChangeTypePresenter
      def self.list_for_dropdown(url)
        options = ChangeType.ordered.select(:id, :name).to_a
        options.prepend(ChangeType.new(name: ""))
        options.map do |ct|
          [
            ct.name,
            ct.id,
            {
              data: {
                frame_url: url.sub("REPLACE_ID", ct.id.to_s)
              }
            }
          ]
        end
      end
    end
  end
end
