module Renalware
  class Admin::UserMailer < ApplicationMailer
    def approval(user)
      @user = user
      mail(to: @user.email, subject: "Renalware account approved")
    end

    def unexpiry(user)
      @user = user
      mail(to: @user.email, subject: "Renalware account reactivated")
    end
  end
end
