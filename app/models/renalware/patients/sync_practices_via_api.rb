# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module Patients
    #
    class SyncPracticesViaApi
      def initialize(api_log:, client: nil, dry_run: false)
        @client = client || NHSApiClient::Organisations::Client.new
        @dry_run = dry_run
        @api_log = api_log
      end

      def call
        if dry_run
          ActiveRecord::Base.transaction do
            sync
            log("Rolling back changes because dry_run=true", flush: true)
            raise ActiveRecord::Rollback
          end
        else
          sync
        end
      end

      private

      attr_reader :client, :dry_run, :api_log

      def sync
        # Fetch each page of organisations from the API
        # Note that the api we are calling does not support a last_change_date > 185 days ago,
        # in which case the client will set it to null so that all records are returned.
        client.fetch_pages(roles: roles, **client_options) do |page| # quit_after: ?
          # For each organisation in the page..
          page.items.each do |item|
            add_or_update_practice(item) if item.last_change_date.present?
          end
          # Save counts after every page
          api_log.pages += 1
          api_log.save
        end
      end

      def client_options
        {
          last_change_date: last_change_date,
          page_size: 100, # defaults to 100, the API page size
          quit_after: 0 # defaults to 0 ie don't stop after n records - keep going
        }
      end

      # This is the date of the last successful sync operation that was not a dry run.
      # Note that if a sync fails midway, the next sync attempt will use the same last_change_date
      # as the failed one. This is not too bad. We will be querying the same number of pages,
      # but we will not have to dig down into each org's page (to get address etc) until we come
      # to the item where the failure happened on the last run. This is because we check the
      # last_change_date on each practice in RW and don't try to update it (fetch extended details
      # from the API) unless date reported in the API is more recent.
      def last_change_date
        LastSuccessfulPracticeSyncDateQuery.new(api_log.identifier).call
      end

      # Returns the added or updated practice
      def add_or_update_practice(item)
        item_already_in_rw = practice_sync_dates.key?(item.org_id) # we found them in RW db
        last_synced_at = practice_sync_dates[item.org_id]
        last_change_date = Date.parse(item.last_change_date)
        log "%-6s %-10s %-2s ", item.org_id, item.status, item_already_in_rw ? "RW" : ""
        practice = nil
        if item_already_in_rw
          if last_synced_at.nil? || last_change_date > last_synced_at
            practice = update_existing_practice(item)
          end
        else
          practice = add_practice(item)
        end
        log flush: true
        practice
      end

      def add_practice(item)
        log "Adding "
        api_log.records_added += 1
        practice = Renalware::Patients::Practice.new
        practice.build_address
        save_practice_changes(practice, item)
      end

      def update_existing_practice(item)
        log "Updating "
        api_log.records_updated += 1
        practice = find_practice_with_code(item.org_id)
        save_practice_changes(practice, item)
      end

      def log(*args, flush: false)
        print sprintf(*args) if args.any?
        puts "" if flush
      end

      def find_practice_with_code(code)
        Renalware::Patients::Practice.find_by!(code: code)
      end

      def save_practice_changes(practice, item)
        practice.assign_attributes(
          code: item.org_id,
          name: item.name,
          telephone: item.details.tel,
          last_change_date: item.last_change_date, # unless we do this, updated_at won't update if no changes
          active: item.status == "Active"
        )
        build_practice_address(practice.address, item)
        practice.save!
        practice
      end

      def build_practice_address(address, item)
        details = item.details
        address.assign_attributes(
          street_1: details.addr_ln1,
          street_2: details.addr_ln2,
          street_3: details.addr_ln3,
          town: details.town,
          county: details.county,
          postcode: details.post_code || "-",
          country_id: uk_country_id,
          region: details.country
        )
        address
      end

      def roles
        %i(practices) # also e.g. branch_surgeries
      end

      def uk_country_id
        @uk_country_id ||= Renalware::System::Country.find_by!(alpha2: "GB").id
      end

      def practice_sync_dates
        @practice_sync_dates ||= begin
          Renalware::Patients::Practice.pluck(:code, :last_change_date).to_h
        end
      end
    end
  end
end
