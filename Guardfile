guard :rspec, cmd: "bundle exec rspec --format progress" do
  watch(%r{^spec/.+_spec\.rb$})
  watch("spec/spec_helper.rb") { "spec" }
  watch("spec/rails_helper.rb") { "spec" }

  watch(%r{^app/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }

  watch(%r{^app/views/(.+)\.(erb|haml|slim)$}) { |m| "spec/views/#{m[1]}_spec.rb" }
  watch(%r{^app/components/(.+)\.rb$}) { |m| "spec/components/#{m[1]}_spec.rb" }

  watch(%r{^config/routes\.rb$}) { "spec/routing" }
  watch(%r{^config/routes/.+\.rb$}) { "spec/routing" }
end

guard :cucumber,
      cmd: "TEST_DEPTH=web bundle exec cucumber",
      cmd_additional_args: "--profile rake_web --publish-quiet",
      notification: false do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/step_definitions/.+\.rb$}) { "features" }
  watch(%r{^features/support/.+\.rb$}) { "features" }
  watch(%r{^app/.+\.(rb|slim|erb|haml)$}) { "features" }
  watch(%r{^config/locales/.+\.ya?ml$}) { "features" }
end
