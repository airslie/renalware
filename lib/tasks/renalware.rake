namespace :renalware do
  desc "Install package.json dependencies with yarn for the renalware-core engine - " \
       "without this <path to installed gem>/renalware-core/node_modules is not populated " \
       "and assets:precompile in the host app will not work."
  task :yarn_install do
    puts "Installing renalware-core/package.json dependencies with yarn"
    Dir.chdir(File.join(__dir__, "../..")) do
      if ENV["RAILS_ENV"] == "production"
        system "yarn install --no-progress --production"
      else
        system "yarn install"
      end
    end
  end
end

if Rake::Task.task_defined?("yarn:install")
  Rake::Task["yarn:install"].enhance(["renalware:yarn_install"])
else
  Rake::Task.define_task("yarn:install" => "renalware:yarn_install")
end
# rubocop:enable Rails/RakeEnvironment

# Run Yarn prior to Sprockets assets pre-compilation, so dependencies are available for use.
if Rake::Task.task_defined?("assets:precompile") && Rails.root.join("bin/yarn").exist?
  Rake::Task["assets:precompile"].enhance ["yarn:install"]
end

Rake::Task["tailwindcss:build"].clear

# Based on the original at tailwindcss-rails/lib/tasks/build.rake
# but using `Renalware::Engine.root` instead of `Rails.root`
namespace :tailwindcss do
  desc "Build your Tailwind CSS"
  task build: :environment do |_, args|
    debug = args.extras.include?("debug")

    command = [
      Tailwindcss::Ruby.executable,
      "-i", Renalware::Engine.root.join("app/assets/stylesheets/application.tailwind.css").to_s,
      "-o", Rails.root.join("app/assets/builds/tailwind.css").to_s,
      "-c", Renalware::Engine.root.join("config/tailwind.config.js").to_s
    ].tap do |cmd|
      cmd << "--minify" unless debug
    end

    puts command.inspect if args.extras.include?("verbose")

    system(*command, exception: true)
  end
end
