# frozen_string_literal: true

require_dependency "renalware/research"
require "document/base"

module Renalware
  module Research
    # Represents a clinical study, e.g. HEROIC.
    #
    # A study can be
    #   - 'vanilla', using just the renalware-core built in Study, Participation and
    #     Investigatorship classes.
    #   - custom, where a host app (or a gem) can defined a custom (jsonb-persisted document
    #     attributes and the html necessary to edit and create that data.
    #
    # A custom study has several elements:
    #  1 study#type - this is the STI type of the class and must be added manually to the row in the
    #    research_studies table in the database. An example might be ::Heroic::Study"
    #  2 study#namespace - this determines which classes are instanciated when building new
    #    Study children (e.g. Participations, Investigatorships) - for example if set to
    #    "::Heroic" then we will try to instanciate an ::Heroic::Participation etc.
    #  3 In the host app you must, in this example, define the following models
    #    app/models/my_study/study.rb
    #    app/models/my_study/participation.rb
    #    app/models/my_study/investigatorship.rb
    #    and in these define a Document class with the extra attributes you want to support, eg
    #
    #    # app/models/my_study/participation.rb
    #    module MyStudy
    #     class Participation < Renalware::Research::Participation
    #       class Document < ::Document::Embedded
    #          attribute :some_attribute, String
    #          validates :some_attribute, presence: true
    #       end
    #       has_document # !important
    #     end
    #   end
    #
    #  4 In the host app define the views to support the new custom types (Document) you have
    #    declared above e.g.
    #    app/views/my_studies/studies/_form.html.slim
    #    app/views/my_studies/participations/_form.html.slim
    #    app/views/my_studies/investigatorships/_form.html.slim
    #
    #    and in these form partials, define the simple_form fields for editing these.
    #
    class Study < ApplicationRecord
      include Accountable
      include Document::Base
      acts_as_paranoid

      validates :code, presence: true, uniqueness: { scope: :deleted_at }
      validates :description, presence: true
      validates :started_on, timeliness: { type: :date, allow_blank: true }
      validates :terminated_on, timeliness: { type: :date, allow_blank: true, after: :started_on }

      scope :ordered, -> { order(code: :asc) }

      has_many :participations,
               class_name: "Participation",
               dependent: :destroy,
               inverse_of: :study

      has_many :patients,
               class_name: "Renalware::User",
               through: :participations

      has_many :investigatorships, dependent: :destroy
      has_many :investigators,
               class_name: "Renalware::User",
               through: :investigatorships

      # Define this explicity so that an subclasses will inherit it - otherwise Pundit will try
      # and resolve eg MyStudy::XxxPolicy which won't exist and not need to the
      # impementor to create.
      def self.policy_class
        StudyPolicy
      end

      class Document < Document::Embedded
        # attribute :example, String
      end
      has_document
    end
  end
end
