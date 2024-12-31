begin
  require "cucumber/rake/task"

  namespace :cucumber do
    Cucumber::Rake::Task.new(:web, "Run cucumber features in Web mode") do |t|
      t.profile = "rake_web"
      t.cucumber_opts = "TEST_DEPTH=web"
    end
  end

  task default: ["cucumber:web"]
rescue LoadError
  desc "cucumber rake task not available (cucumber not installed)"
  task :cucumber do
    abort "Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin"
  end
end
