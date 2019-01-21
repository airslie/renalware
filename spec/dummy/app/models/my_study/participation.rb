# frozen_string_literal: true

# RW will look up this class name based on the namespace column in the study has
# the string "DummyStudy".
# For example when a new participant is added to a study that has the string "Research::DummyStudy"
# in the namespace column, it will try and find the class
# DummyStudy::Participant. Likewise for DummyStudy::Investigatorship.
# If those classes are not defined it falls back to using the built-in Participant
# and Investigatorship classes. Either way, STI takes care of storing the
# class name when thre recordd is saved.
module MyStudy
  class Participation < Renalware::Research::Participation
    # Augment the base Document by adding some fields...
    class Document < Renalware::Research::Participation::Document
      attribute :some_attribute, String
      validates :some_attribute, presence: true
    end
    has_document class_name: "Document"
  end
end
