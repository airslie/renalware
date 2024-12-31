module Renalware
  class RolesUser < ApplicationRecord
    belongs_to :role
    belongs_to :user
  end
end
