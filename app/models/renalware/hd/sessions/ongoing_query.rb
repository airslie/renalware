module Renalware
  module HD
    module Sessions
      class OngoingQuery
        def initialize(q: nil)
          @q = q || { s: "started_at desc" }
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
