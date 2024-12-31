module Renalware
  module Letters
    class PdfLetterCacheController < BaseController
      def destroy
        authorize %i(renalware admin cache), :destroy?
        Renalware::Letters::PdfLetterCache.clear
        redirect_to admin_cache_path, notice: "Cache successfully cleared"
      end
    end
  end
end
