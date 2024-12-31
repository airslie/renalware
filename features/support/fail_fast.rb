# `FAST=1 cucumber` to stop on first failure
After do |scenario|
  Cucumber.wants_to_quit = true if ENV["FAST"] && scenario.failed?
end
