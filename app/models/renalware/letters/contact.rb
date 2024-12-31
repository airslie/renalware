module Renalware
  module Letters
    class Contact < ApplicationRecord
      belongs_to :patient, touch: true
      belongs_to :person, class_name: "Directory::Person"
      belongs_to :description, class_name: "ContactDescription"

      validates :person, presence: true, uniqueness: { scope: :patient }
      validates :description, presence: true
      validates :other_description, presence: true, if: -> { unspecified_description? }

      delegate :salutation, to: :person
      delegate :address, :to_s, :family_name, :full_name, to: :person
      delegate :name, to: :address, prefix: true

      accepts_nested_attributes_for :person

      scope :with_person, -> { includes(person: :address) }
      scope :with_description, -> { includes(:description) }
      scope :ordered, lambda {
        with_person.order("directory_people.family_name, directory_people.given_name")
      }

      scope :default_ccs, -> { where(default_cc: true) }

      def self.locate_by_given_name(name)
        with_person.find_by(directory_people: { given_name: name })
      end

      def self.policy_class = BasePolicy

      def described_as?(description)
        (self.description == description) || (other_description == description)
      end

      def unspecified_description?
        description.try(:unspecified?)
      end
    end
  end
end
