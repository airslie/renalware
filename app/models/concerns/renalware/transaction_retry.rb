module Renalware
  module TransactionRetry
    extend ActiveSupport::Concern

    included do
      # Retry a transaction automatically when an ActiveRecord::PreparedStatementCacheExpired error
      # is raised. This handles a specific scenario where there is a migration run during a deploy
      # that changes one or more columns used in a cached PostgreSQL prepared statement.
      # We rescue it here and retry (once) the txn to prevent users getting an error when they try
      # to select/update data moments after the deploy.
      #
      # Do not use this for transactions with side-effects unless it is acceptable
      # for these side-effects to occasionally happen twice.
      #
      # Note we define this method in the included block (not the class_methods block as you would
      # expect) because in the latter case a client calling #transaction would get the including
      # class's transaction method, not the overriding one defined here. Using 'included' allows
      # use to get around this. See comments in
      # https://github.com/rails/rails/blob/master/activesupport/lib/active_support/concern.rb
      #
      def self.transaction(*args, &)
        retried ||= false
        super
      rescue ActiveRecord::PreparedStatementCacheExpired
        if retried
          raise
        else
          retried = true
          retry
        end
      end
    end
  end
end
