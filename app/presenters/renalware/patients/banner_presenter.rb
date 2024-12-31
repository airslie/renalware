module Renalware
  module Patients
    class BannerPresenter < SimpleDelegator
      def current_modality_description
        if current_modality.blank? || current_modality.new_record?
          I18n.t("renalware.modalities.none")
        else
          current_modality.description.augmented_name_for(__getobj__)
        end
      end
    end
  end
end
