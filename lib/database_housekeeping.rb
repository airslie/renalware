# frozen_string_literal: true

# Responsible for reducing database clutter and thus keeping the database size
# and its backups down to a reasonable size.
# Note some of the housekeeping concerns here eg UKRDC could perhaps be dealt with as a
# method for example on UKRDC::TransmissionLog - perhaps something to improve
# at some point.
# rubocop:disable-next Rails/Output
class DatabaseHousekeeping
  def call
    clear_old_ukrdc_transmission_logs
    clear_old_hd_transmission_logs
    clear_old_system_visit_and_events
  end

  private

  def clear_old_ukrdc_transmission_logs
    puts " Clear old ukrdc_transmission_logs"
    Renalware::UKRDC::TransmissionLog
      .where(created_at: ...2.months.ago)
      .delete_all
  end

  def clear_old_hd_transmission_logs
    puts " Clear old hd_transmission_logs"
    Renalware::HD::TransmissionLog
      .where(created_at: ...2.weeks.ago)
      .delete_all
  end

  def clear_old_system_visit_and_events
    puts " Clear old system visits and events"
    retention_period = ActiveSupport::Duration.parse(
      ENV.fetch("SYSTEM_VISITS_AND_EVENTS_RETENTION_PERIOD", "P12M")
    )
    now = Time.current
    # Compare calendar cutoffs to guarantee at least six months of audit data is retained.
    cutoff = [retention_period.ago(now), 6.months.ago(now)].min

    Renalware::System::Event.where(time: ...cutoff).delete_all
    Renalware::System::Visit.where(started_at: ...cutoff).delete_all
  end
end
