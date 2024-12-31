module Renalware
  module PdfHelper
    def find_asset_str(path)
      Rails.application.assets.find_asset(path).to_s
    end
  end
end
