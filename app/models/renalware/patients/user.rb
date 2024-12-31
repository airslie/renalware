module Renalware
  module Patients
    class User < Renalware::User
      has_many :bookmarks, dependent: :restrict_with_exception
      has_many :patients, through: :bookmarks

      def self.model_name = ActiveModel::Name.new(self, nil, "User")
      def bookmark_for_patient(patient) = bookmarks.find_by(patient: patient)
    end
  end
end
