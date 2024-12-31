# Various rake tasks for importing flat file feeds
begin
  namespace :feeds do
    namespace :files do
      # TEST_ZIP_FILE_PATH = "/Users/tim/Downloads/hscorgrefdataxml_data_1.0.1_20170526000001.zip"
      desc "Import GPs"
      # Test file at "/Users/tim/Downloads/nhs_odsweekly_6.2.0_20170615000001.zip"
      task :import_gps, [:absolute_zip_file_path] => [:environment] do |task, args|
        file = Renalware::Feeds::File.build(
          location: args.fetch(:absolute_zip_file_path),
          file_type: :primary_care_physicians
        )
        file.save!
        Renalware::Feeds::Files::PrimaryCarePhysicians::ImportJob.perform_now(file)
      end
    end
  end
end
