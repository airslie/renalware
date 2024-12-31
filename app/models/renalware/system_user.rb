module Renalware
  class SystemUser
    USERNAME = "systemuser".freeze

    def self.username = USERNAME
    def self.find = User.find_by!(username: username)
  end
end
