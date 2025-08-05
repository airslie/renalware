namespace :forms do
  namespace :homecare do
    desc "Generate test Homecare Supply PDF"
    task :build, [:provider] => :environment do |_t, args|
      include Forms::Helpers

      provider = args[:provider]

      if provider.nil?
        puts "Supply a provider. I.e."
        puts "  rails forms:homecare:build[generic|fresenius|alcura]"
        exit 1
      end

      args = Forms::Homecare::Args.test_data(provider:)
      pdf = Forms::Homecare::Pdf.generate(args)
      render_and_open pdf
    end
  end
end
