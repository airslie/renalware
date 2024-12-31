module Renalware
  module UsingTempFolder
    extend ActiveSupport::Concern

    def in_a_temporary_folder
      Dir.mktmpdir(nil, Rails.root.join("tmp").to_s) do |dir|
        yield Pathname(dir)
        # temp dir removed here
      end
    end
  end
end
