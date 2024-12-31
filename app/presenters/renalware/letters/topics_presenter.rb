module Renalware
  module Letters
    class TopicsPresenter
      def self.list_for_dropdown(url)
        Topic.ordered.select(:id, :text).map do |topic|
          [
            topic.text,
            topic.id,
            {
              data: {
                frame_url: url.sub("REPLACE_ID", topic.id.to_s)
              }
            }
          ]
        end
      end
    end
  end
end
