# frozen_string_literal: true

# Responsible for reducing database clutter and thus keeping the database size
# and its backups down to a reasonable size.
# Note some of the housekeeping concerns here eg UKRDC could perhaps be dealt with as a
# method for example on UKRDC::TransmissionLog - perhaps something to improve
# at some point.
# rubocop:disable Rails/Output
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
    Renalware::System::Event.where(time: ...6.months.ago).delete_all
    Renalware::System::Visit.where(started_at: ...6.months.ago).delete_all
  end
end
# rubocop:enable Rails/Output
