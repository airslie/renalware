# frozen_string_literal: true

module Renalware
  module HospitalsHelper
    def ward_dropdown_grouped_by_hospital_unit(form, attribute, **options)
      form.input(
        attribute.to_sym,
        as: :grouped_select,
        group_method: :wards,
        collection: Renalware::Hospitals::WardPresenter.units_with_wards,
        label_method: lambda { |ward|
          Renalware::Hospitals::WardPresenter.new(ward).title_including_unit
        },
        wrapper: :horizontal_medium,
        input_html: { class: "searchable_select" },
        **options
      )
    end

    def ward_title(ward)
      ward_label = ward.name.blank? ? ward.code : "#{ward.name} (#{ward.code})"
      "#{ward.hospital_unit.unit_code} / #{ward_label}"
    end
  end
end
