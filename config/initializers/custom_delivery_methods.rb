# Note we need to revisit this so that these are added before the
# lib/configuration code, so we can use an ENV var to set the delivery method and also
# and check it exists eg
#  method = read ENV var and convert to symbol
#  raise unless ActionMailer::Base.add_delivery_methods[method].present?
#  config.action_mailer.delivery_method = method
#
require "action_mailer/base" # required for on_load(:action_mailer) to fire

ActiveSupport.on_load(:action_mailer) do
  require "microsoft_graph/delivery_method"
  require "send_grid_helper/delivery_method"

  ActionMailer::Base.add_delivery_method :microsoft_graph_api, MicrosoftGraph::DeliveryMethod
  ActionMailer::Base.add_delivery_method :sendgrid_api, SendGridHelper::DeliveryMethod

  # Now validate & apply chosen mail delivery method
  meth = Renalware.config.mail_delivery_method

  unless ActionMailer::Base.delivery_methods.key?(meth)
    raise "Invalid MAIL_DELIVERY_METHOD=#{meth.inspect}. " \
          "Valid: #{ActionMailer::Base.delivery_methods.keys.sort.join(', ')}"
  end

  Rails.application.config.action_mailer.delivery_method = meth
end
