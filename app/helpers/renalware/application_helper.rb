require "inline_image"
require "git_commit_sha"
require "breadcrumb"

module Renalware
  module ApplicationHelper
    include Renalware::Engine.routes.url_helpers
    include Pagy::Frontend

    # If a consumer (eg a report) wants to generate a link to a patient page in a certain module/
    # context, as a convenience for the user, then this helper will generate a link to a url e.g.
    # create the route "/patients/77f2348e49f4451b976e85bc635e71c6/hd" if "hd" is passed.
    # This assume however that we have correctly defined convenience redirects in the various
    # routes files so that , in this instance, ./hd redirects to ./hd/dashboard
    # Using a simple convenience route like this means the routes file for each module can
    # itself determine what the default page is, to avoid cross-module contamination.
    def patient_link(patient, landing_page:)
      landing_page ||= :clinical_summary
      landing_page = "" if landing_page.to_sym == :demographics
      route_name = "patient_#{landing_page.downcase}_path".gsub("__", "_")
      url = renalware.public_send(route_name, patient)
      link_to(patient.to_s(:default), url, "data-turbo-frame": "_top")
    end

    def default_patient_link(patient)
      link_to(
        patient.to_s(:default),
        renalware.patient_clinical_summary_path(patient),
        data: { turbo_frame: "_top" }
      )
    end

    def default_patient_link_with_nhs_number(patient)
      link_to(
        patient&.to_s(:long),
        renalware.patient_clinical_summary_path(patient),
        "data-turbo-frame": "_top"
      )
    end

    def patient_search
      ::Renalware::Patients::PatientSearch.call(params)
    end

    # For use in layouts
    def page_title(separator = Renalware.config.page_title_spearator)
      [
        content_for(:page_title),
        Renalware.config.site_name
      ].compact.join(separator)
    end

    def breadcrumb_for(title, url)
      Breadcrumb.new(title: title, anchor: link_to(title, url))
    end

    def flash_messages
      flash.to_hash.reject { |key| key.to_sym == :timedout }
    end

    # For use in pages
    def page_heading(title)
      content_for(:page_title) { title.html_safe }
    end

    def t?(key)
      t(key, cascade: false, raise: false, default: "").present?
    end

    def errors_css_class(model, attr)
      " field_with_errors" if model.errors.key?(attr)
    end

    def default_for_associated(assoc, method, msg)
      assoc.present? ? assoc.public_send(method) : msg
    end

    def default_for_blank(val, msg)
      val.presence || msg
    end

    def default_for_blank_date(date, msg)
      date.blank? ? msg : l(date)
    end

    def default_for_blank_units(val, unit, msg)
      val.blank? ? msg : "#{val} #{unit}"
    end

    def pipe_separator
      "&nbsp;|&nbsp;".html_safe
    end

    def blank_separator
      "&nbsp;".html_safe
    end

    def inline_image_tag(file_path, options = {})
      image = inline_image(file_path)
      image_tag(image.src, options)
    end

    def inline_image(file_path)
      InlineImage.new(asset_path(file_path))
    end

    def modality_description_for(modality)
      if modality.blank? || modality.new_record?
        I18n.t("renalware.modalities.none")
      else
        modality.description.name
      end
    end

    def semantic_app_version
      "#{Renalware::VERSION} build #{GitCommitSha.current}"
    end
  end
end
