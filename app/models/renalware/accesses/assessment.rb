require_dependency "renalware/accesses"
require "document/base"

module Renalware
  module Accesses
    class Assessment < ActiveRecord::Base
      include Document::Base
      include Accountable
      extend Enumerize

      belongs_to :patient
      belongs_to :type, class_name: "Type"
      belongs_to :site, class_name: "Site"

      has_document class_name: "Renalware::Accesses::AssessmentDocument"
      has_paper_trail class_name: "Renalware::Accesses::Version"

      scope :ordered, -> () { order(performed_on: :desc) }

      validates :type, presence: true
      validates :site, presence: true
      validates :side, presence: true
      validates :performed_on, presence: true
      validates :performed_on, timeliness: { type: :date, allow_blank: false }
      validates :procedure_on, timeliness: { type: :date, allow_blank: true }

      enumerize :side, in: %i(left right)
    end
  end
end