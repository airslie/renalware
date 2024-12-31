require "fileutils"

module Renalware
  module Letters
    # Used for example in a host app like renalware-blt to generate an RTF letter for saving to
    # the electronic public register, aka EPR/CRS.
    class SaveRTFLetterToFileJob < ApplicationJob
      self.log_arguments = false
      queue_as :rtf_generation
      queue_with_priority 1
      retry_on Errno::EPIPE, wait: 10.minutes, attempts: 3

      def perform(args)
        letter = args[:letter]
        file_path = args[:file_path]
        file_path = Pathname(file_path)
        create_folder_if_not_exists(file_path)
        File.open(file_path, "wb") { |file| file << rtf_data_for(letter) }
      end

      def rtf_data_for(letter)
        RendererFactory.renderer_for(letter, :rtf).call
      end

      def create_folder_if_not_exists(path)
        FileUtils.mkdir_p(path.dirname)
      end
    end
  end
end
