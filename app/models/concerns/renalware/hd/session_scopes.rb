module Renalware
  module HD
    module SessionScopes
      def with_sessions_falling_within(period)
        falling_within(period)
      end

      # TODO: Refactor to two methods/scopes or'ed together e.g. finished_closed.or.finished_dna
      def falling_within(range)
        where(hd_sessions: {
                type: Session::Closed.sti_name,
                signed_off_at: range
              }).or(
                where(hd_sessions: {
                        type: Session::DNA.sti_name,
                        started_at: range
                      })
              )
      end

      def with_finished_sessions
        finished
      end

      def finished
        where(hd_sessions: { type: [Session::Closed.sti_name, Session::DNA.sti_name] })
      end
    end
  end
end
