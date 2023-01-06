# See https://pawelurbanek.com/rails-console-environment
# Add eg 'Renalware (development) >' prompt in the rails console.
# Use a red prompt in production.
#
# Enable in the host applications's config/application.rb:
#  console do
#    ARGV.push "-r", Renalware::Engine.root.join("config/initializers/console_prompt.rb")
#  end

require "irb"

env = Rails.env
env_color = if env.production?
              "\e[31m#{env}\e[0m"
            else
              env
            end

IRB.conf[:PROMPT] ||= {}
IRB.conf[:PROMPT][:RAILS_APP] = {
  PROMPT_I: "Renalware (#{env_color}) > ",
  PROMPT_S: "Renalware (#{env_color}) * ",
  PROMPT_C: "Renalware (#{env_color}) ? ",
  RETURN: "=> %s\n"
}

IRB.conf[:PROMPT_MODE] = :RAILS_APP
