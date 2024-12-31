require "microsoft_graph/delivery_method"

ActionMailer::Base.add_delivery_method :microsoft_graph_api, MicrosoftGraph::DeliveryMethod
