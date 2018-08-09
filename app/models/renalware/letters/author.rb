# frozen_string_literal: true

require_dependency "renalware/letters"

module Renalware
  module Letters
    class Author < ActiveType::Record[Renalware::User]
      has_many :letters, dependent: :restrict_with_exception
    end
  end
end
