namespace :cache do
  namespace :pdf do
    desc "Clean the PDF letter cache ie remove expired content." \
         "Note this might be clearing a FileStore cache based on a directory " \
         "or clearing a DatabaseStore cache if enabled, which removed expired rows from the " \
         "renalware.activesupport_cache_entries table. The latter is enabled if the " \
         "activesupport_cache_database gem is installed"
    task cleanup: :environment do
      Renalware::Letters::PdfLetterCache.cleanup
    end
  end
end
