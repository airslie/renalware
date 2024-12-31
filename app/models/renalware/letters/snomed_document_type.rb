module Renalware
  module Letters
    class SnomedDocumentType < ApplicationRecord
      validates :title, presence: true, uniqueness: true
      validates :code, presence: true, uniqueness: true
    end
  end
end
