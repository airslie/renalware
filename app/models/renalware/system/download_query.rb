module Renalware
  module System
    class DownloadQuery
      attr_reader :query_params

      def initialize(query_params)
        @query_params = query_params || {}
      end

      def call
        search.result.includes(:updated_by)
      end

      def search
        @search ||= Download.order(view_count: :desc, name: :asc).ransack(query_params)
      end
    end
  end
end
