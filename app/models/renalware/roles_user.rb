module Renalware
  class RolesUser < ApplicationRecord
    belongs_to :role
    belongs_to :user

    has_paper_trail(versions: { class_name: "Renalware::System::Version" })
  end
end
