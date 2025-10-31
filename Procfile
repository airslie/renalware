# Heroku Procfile - use Procfile.dev in development
web: bundle exec puma -C ./demo/config/puma.rb

# Note we switched to using good_job execution_mode :async which is in-process so no need for worker
# worker: bundle exec rake app:jobs:work

release: bundle exec rake assets:precompile && bundle exec rake db:prepare
