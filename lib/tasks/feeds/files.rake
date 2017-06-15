# Various rake tasks for importing flat file feeds
begin
  namespace :feeds do
    namespace :files do
      # TODO: For some reason this is not showing up doing a rake -T
      # Test file at = "/Users/tim/Downloads/hscorgrefdataxml_data_1.0.1_20170526000001.zip"
      desc "Import Practices from a zip file downloaded from "\
           "https://isd.digital.nhs.uk/trud3/user/authenticated/group/0/pack/5/subpack/341/releases " \
           "Note: if using zsh, you must escape the brackets around the argument when calling "\
           "e.g. "\
           "`$ RAILS_LOG_TO_STDOUT=1 bundle exec rake app:feeds:files:import_practices\[/Users/me/x/w/z.zip\]`"
      task :import_practices, [:absolute_zip_file_path] => [:environment] do |task, args|
        file = Renalware::Feeds::File.build(
          location: args.fetch(:absolute_zip_file_path),
          file_type: :practices
        )
        file.save!
        Renalware::Feeds::Files::Practices::ImportJob.perform_now(file)
      end

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
