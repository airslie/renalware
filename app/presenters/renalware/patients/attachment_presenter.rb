module Renalware
  module Patients
    class AttachmentPresenter < SimpleDelegator
      delegate :byte_size, :content_type, to: :blob

      def size
        "#{byte_size / 1000} KB" if file.attached?
      end

      def blob
        file.attached? ? file.blob : NullObject.instance
      end
    end
  end
end
