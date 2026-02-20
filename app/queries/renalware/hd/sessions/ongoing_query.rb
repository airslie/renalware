module Renalware
  module HD
    module Sessions
      class OngoingQuery
        def initialize(q: nil)
          @q = q || {}
          @q[:s] = "started_at desc" if @q[:s].blank?
        end

        def call
          search.result
        end

        def search
          @search ||= Session::Open.ransack(@q)
        end
      end
    end
  end
end
