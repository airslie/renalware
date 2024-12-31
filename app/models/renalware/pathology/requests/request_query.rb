module Renalware
  module Pathology
    module Requests
      class RequestQuery
        attr_reader :requests, :query

        def initialize(q = {})
          @q = q
          @q[:s] = "created_at DESC" if @q[:s].blank?
        end

        def call
          search.result.includes(:patient, :clinic, :consultant)
        end

        def search
          @search ||= Request.include(QueryableRequest).ransack(@q)
        end

        module QueryableRequest
          extend ActiveSupport::Concern
          included do
            ransacker :created_on, type: :date do
              Arel.sql("DATE(created_at)")
            end
          end
        end
      end
    end
  end
end
