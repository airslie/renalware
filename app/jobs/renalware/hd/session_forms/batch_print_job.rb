module Renalware
  module HD
    module SessionForms
      class BatchPrintJob < ApplicationJob
        include UsingTempFolder

        # Returns the name of a temp file containing the pdf data
        def perform(batch_id, user_id)
          in_a_temporary_folder do |dir|
            Dir.chdir(dir) do
              batch = Batch.find(batch_id)
              user = User.find(user_id)
              BatchCompilePdfs.call(batch, user)
            end
          end
        end

        discard_on StandardError

        def queue_name = "hd_session_forms"
        def priority = 0
        def destroy_failed_jobs? = true
      end
    end
  end
end
