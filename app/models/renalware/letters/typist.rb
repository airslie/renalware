module Renalware
  module Letters
    # Represents the role of a system user who typed the letter. This role maybe
    # played by support staff of the doctor such as a secretary. This is
    # different from the role of Author who will always be a doctor.
    #
    class Typist < Renalware::User
      has_many :letters, foreign_key: :created_by_id
    end
  end
end
