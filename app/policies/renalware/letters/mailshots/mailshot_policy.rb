module Renalware
  module Letters
    module Mailshots
      class MailshotPolicy < BasePolicy
        def new?    = user_is_super_admin?
        def create? = new?
        def index?  = user_is_super_admin? || user_is_admin?
      end
    end
  end
end
