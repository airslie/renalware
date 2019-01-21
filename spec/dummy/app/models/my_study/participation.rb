# frozen_string_literal: true

# RW will look up this class name based on the namespace column in the study has
# the string "MyStudy".
# For example when a new participant is added to a study that has the string "::MyStudy"
# in the namespace column, it will try and find the class
# MyStudy::Participant. Likewise for MyStudy::Investigatorship.
# If those classes are not defined it will raise an error.
# STI and the `type` column take care of storing the class name when the record is saved.
module MyStudy
  class Participation < Renalware::Research::Participation
    # Augment the base Document by adding some fields...
    class Document < Renalware::Research::Participation::Document
      attribute :some_attribute, String
      validates :some_attribute, presence: true
    end
    has_document
  end
end
