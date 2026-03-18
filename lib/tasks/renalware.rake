# This app keeps Tailwind's generated CSS in app/assets/builds so Sprockets can serve it.
# Override the gem task to build from this app's non-default input path.
Rake::Task["tailwindcss:build"].clear if Rake::Task.task_defined?("tailwindcss:build")

namespace :tailwindcss do
  desc "Build your Tailwind CSS"
  task build: :environment do |_, args|
    debug = args.extras.include?("debug")

    command = [
      Tailwindcss::Ruby.executable,
      "-i", Rails.root.join("app/assets/stylesheets/application.tailwind.css").to_s,
      "-o", Rails.root.join("app/assets/builds/tailwind.css").to_s,
      "-c", Rails.root.join("config/tailwind.config.js").to_s
    ]
    command << "--minify" unless debug

    puts command.inspect if args.extras.include?("verbose")

    system(*command, exception: true)
  end
end
