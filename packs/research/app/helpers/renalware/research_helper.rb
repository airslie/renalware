# frozen_string_literal: true

module Renalware
  module ResearchHelper
    # Given an STI class name like "Renalware::Heroic::Research::Study" we extract the
    # namespace so we can build derive the partial path for a type like :participation, e.g.
    # "Renalware::Heroic::Research::Participation"
    #
    # Example usage:
    # path_to_research_document_form_partial(
    #   "Renalware::Heroic::Research::Study",
    #   :participation
    # )
    def path_to_research_document_form_partial(study_class, type = nil)
      return if study_class.blank?

      partial_path = "#{study_class.deconstantize.underscore}/#{type}/form"
      partial_path&.gsub("::", "/")&.gsub("//", "/")&.gsub("//", "/")
    end

    def path_to_research_show_partial(study_class, type = nil)
      return if study_class.blank?

      partial_path = "#{study_class.deconstantize.underscore}/#{type}/show"
      partial_path&.gsub("::", "/")&.gsub("//", "/")&.gsub("//", "/")
    end

    def research_study_participants_breadcrumb(study)
      research_study_breadcrumb(study).append(
        breadcrumb_for("Participants", research.study_participations_path(study))
      )
    end

    def research_study_investigators_breadcrumb(study)
      research_study_breadcrumb(study).append(
        breadcrumb_for("Investigators", research.study_investigatorships_path(study))
      )
    end

    def research_study_breadcrumb(study)
      [
        breadcrumb_for("Clinical Studies", research.studies_path),
        breadcrumb_for(study.code, research.study_path(study))
      ]
    end
  end
end
