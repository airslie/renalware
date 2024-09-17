# frozen_string_literal: true

module Renalware
  module Directory
    class PersonQuery
      def initialize(q: nil)
        @q = q || {}
        @q[:s] ||= ["family_name asc", "given_name asc"]
      end

      def call
        search.result
      end

      def search
        @search ||= Person.include(QueryablePerson).ransack(@q)
      end

      module QueryablePerson
        extend ActiveSupport::Concern
        included do
          ransack_alias :name, :family_name_or_given_name
        end
      end
    end
  end
end
