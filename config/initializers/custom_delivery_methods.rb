require "microsoft_graph/delivery_method"
require "send_grid_helper/delivery_method"

# Note we need to revisit this so that these are added before the
# lib/configuration code, so we can use an ENV var to set the delivery method and also
# and check it exists eg
#  method = read ENV var and convert to symbol
#  raise unless ActionMailer::Base.add_delivery_methods[method].present?
#  config.action_mailer.delivery_method = method
#
ActionMailer::Base.add_delivery_method :microsoft_graph_api, MicrosoftGraph::DeliveryMethod
ActionMailer::Base.add_delivery_method :sendgrid_api, SendGridHelper::DeliveryMethod
