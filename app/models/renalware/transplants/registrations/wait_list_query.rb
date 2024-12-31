module Renalware
  module Transplants
    module Registrations
      class WaitListQuery
        def initialize(named_filter:, ukt_recipient_number: nil, q: nil)
          @named_filter = named_filter&.to_sym || :active
          @q = (q || ActionController::Parameters.new).permit(:s, :q)
          @ukt_recipient_number = ukt_recipient_number
        end

        def call
          search
            .result
            .extending(Scopes)
            .apply_filter(named_filter)
            .having_ukt_recipient_number(ukt_recipient_number)
        end

        def search
          @search ||= begin
            query = query_for_filter(named_filter).merge(q)
            Registration
              .include(QueryableRegistration)
              .eager_load(patient: [current_modality: :description])
              .eager_load(current_status: :description)
              .merge(HD::Patient.with_profile)
              .merge(Renal::Patient.with_profile)
              .ransack(query).tap do |s|
              s.sorts = ["patient_family_name, patient_given_name"]
            end
          end
        end

        # The status_mismatch filter finds patients with a UKT status that does not match their
        # tx wait list status. We filter out UKT statuses of null or ''.
        # At some point we will have turn this into a mapping object or hash because there will
        # probably not be a 1 to 1 mapping from wait list to UKT status.
        module Scopes
          def having_ukt_recipient_number(number)
            return all if number.blank?

            where(<<-SQL.squish, number)
              transplant_registrations.document -> 'codes' ->> 'uk_transplant_patient_recipient_number' = ?
            SQL
          end

          def apply_filter(filter)
            case filter
            when :status_mismatch
              joins(statuses: :description)
                .where(transplant_registration_statuses: { terminated_on: nil })
                .where(
                  <<-SQL.squish
                  (
                    transplant_registration_status_descriptions.code in ('active')
                    and
                    (
                      transplant_registrations.document -> 'uk_transplant_centre' ->> 'status' not ilike 'A'
                    )
                  )
                  or
                  (
                    transplant_registration_status_descriptions.code not in ('active')
                    and
                    (
                      transplant_registrations.document -> 'uk_transplant_centre' ->> 'status' ilike 'A'
                    )
                  )
                  SQL
                )
            else
              all
            end
          end
        end

        private

        attr_reader :q, :named_filter, :ukt_recipient_number

        def query_for_filter(filter)
          case filter
          when :all
            {}
          when :active
            { current_status_in: :active }
          when :suspended
            { current_status_in: :suspended }
          when :active_and_suspended
            # NOTE: array must be embedded in another array as mentioned here:
            # https://github.com/activerecord-hackery/ransack#using-scopesclass-methods
            { current_status_in: [%w(active suspended)] }
          when :working_up
            { current_status_in: [%w(working_up working_up_lrf)] }
          when :status_mismatch
            {} # See Scopes
          end
        end

        module QueryableRegistration
          extend ActiveSupport::Concern

          included do
            scope :current_status_in, lambda { |codes|
              codes ||= %w(active)
              joins(statuses: :description)
                .where(transplant_registration_statuses: { terminated_on: nil })
                .where(transplant_registration_status_descriptions: { code: codes })
            }

            ransacker :crf_highest_value do
              Arel.sql("transplant_registrations.document -> 'crf' -> 'highest' ->> 'result'")
            end

            ransacker :crf_latest_value do
              Arel.sql("transplant_registrations.document -> 'crf' -> 'latest' ->> 'result'")
            end

            # TODO: move ransacker to HD namespace
            ransacker :hd_site do
              Arel.sql("hospital_units.unit_code")
            end

            # TODO: move ransacker to Renal namespace
            ransacker :esrf_on do
              Arel.sql("renal_profiles.esrf_on")
            end

            # TODO: move ransacker to Renal namespace
            ransacker :patient_current_status_description_name do
              Arel.sql("transplant_registration_status_descriptions.name")
            end

            ransacker :ukt_status do
              Arel.sql(<<-SQL.squish)
                COALESCE(
                  transplant_registrations.document -> 'uk_transplant_centre' ->> 'status',
                  ''
                )
              SQL
            end

            private_class_method :ransackable_scopes

            def self.ransackable_scopes(_auth_object = nil)
              %i(current_status_in ukt_recipient_number_eq)
            end
          end
        end
      end
    end
  end
end
