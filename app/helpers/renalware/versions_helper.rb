module Renalware
  module VersionsHelper
    def who_did_it(model)
      if model.whodunnit
        user_id = model.whodunnit.to_i
        if (user = User.find_by(id: user_id))
          user.full_name
        else
          "User #{user_id}"
        end
      else
        "System"
      end
    end
  end
end
