require "active_support/concern"

module Renalware
  module Concerns::ResumeAfterSignIn
    extend ActiveSupport::Concern

    def after_sign_in_path_for(user)
      Users::ResumeLocation.new(session).consume_for(user) || super
    end
  end
end
