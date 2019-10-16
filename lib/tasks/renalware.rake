# frozen_string_literal: true

def ensure_log_goes_to_stdout
  old_logger = Webpacker.logger
  Webpacker.logger = ActiveSupport::Logger.new(STDOUT)
  yield
ensure
  Webpacker.logger = old_logger
end

namespace :renalware do
  desc "Install package.json dependencies with yarn for the renalware-core engine - "\
       "without this <path to installed gem>/renalware-core/node_modules is not populated "\
       "and assets:precompile in the host app will not work."
  task :yarn_install do
    puts "Installing renalware-core/package.json dependencies with yarn"
    Dir.chdir(File.join(__dir__, "../..")) do
      system "yarn install --no-progress --production"
    end
  end

  desc "Cleans the Webpack output folder (public/renalware-core-packs)"
  task :clean_webpack_output_folder do
    puts "Destroying packs output folder ..."
    Dir.chdir(File.join(__dir__, "..", "..")) do
      # TODO : Load packs output from config/webpacker.yml
      system "rm -rf public/renalware-core-packs"
    end
  end

  # I have found that it is necessary to force remove public/renalware-core-packs with the
  # clean_webpack_output_folder task above before compiling, otherwise webpack does not
  # always find changes in js/controllers/*.js. I think this is safe to do in a capistrano deploy
  # because the symlink to public is only applied after a successful execution of (among other
  # things) assets:precompile.
  desc "Compile JavaScript packs using webpack for production with digests"
  task webpacker_compile: %i(clean_webpack_output_folder yarn_install environment) do
    puts "Compiling renalware-core packs with webpack.."
    Webpacker.with_node_env("production") do
      ensure_log_goes_to_stdout do
        if Renalware.webpacker.commands.compile
          # Successful compilation!
        else
          # Failed compilation
          exit!
        end
      end
    end
  end
end

def enhance_assets_precompile_with_renalware_webpacker_compile
  Rake::Task["assets:precompile"].enhance(["renalware:webpacker_compile"])
end

# When a host app runs rake assets:precompile, hook into this and enhance the
# task so it runs webpacker install for (and relative to) the engine, wherever it is installed.
# Without that, assets:precompile will fail because the engine references various js and css files
# in ./node_modules, and these are not included in the source, but need to be installed with yarn
# at deploy time.
#
# Note that when runnning in the engine in development, we need to set the ENV
# var WEBPACKER_PRECOMPILE=no (e.g. in ./.env) otherwise wepacker will enhance the
# 'assets:precompile' task with 'webpacker:compile' task, and the latter task does not exist
# in out context (for us its called app:webpacker:compile).
# A possible downside of this is that webpacker compilation in the dummy app, if ever required, may
# not work, I'm not sure.
if Rake::Task.task_defined?("assets:precompile")
  enhance_assets_precompile_with_renalware_webpacker_compile
else
  Rake::Task.define_task("assets:precompile" => "renalware:webpacker:compile")
end
