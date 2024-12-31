module Renalware
  # Preview all emails at http://localhost:3000/rails/mailers
  class Admin::UserMailerPreview < ActionMailer::Preview
    def approval
      user = User.first
      Admin::UserMailer.approval(user)
    end

    def unexpiry
      user = User.first
      Admin::UserMailer.unexpiry(user)
    end
  end
end
