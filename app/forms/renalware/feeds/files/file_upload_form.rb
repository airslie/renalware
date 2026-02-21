module Renalware
  module Feeds
    module Files
      class FileUploadForm
        include ActiveModel::Model
        include Virtus::Model

        attribute :file
        attribute :file_type_id

        validates :file, presence: true
        validates :file_type_id, presence: true

        def file_type_dropdown_options
          FileType.pluck(:id, :name, :prompt).map do |id, name, prompt|
            ["#{name.humanize} - #{prompt}", id]
          end
        end
      end
    end
  end
end
