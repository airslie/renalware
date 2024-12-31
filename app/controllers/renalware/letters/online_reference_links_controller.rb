module Renalware
  module Letters
    class OnlineReferenceLinksController < Letters::BaseController
      def index
        links = System::OnlineReferenceLink.all
        authorize links
        render locals: { links: links }
      end
    end
  end
end
