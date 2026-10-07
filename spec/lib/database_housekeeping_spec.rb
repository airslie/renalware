require "database_housekeeping"

RSpec.describe DatabaseHousekeeping do
  around do |example|
    key = "SYSTEM_VISITS_AND_EVENTS_RETENTION_PERIOD"
    original_value = ENV.fetch(key, nil)
    ENV.delete(key)
    example.run
  ensure
    original_value.nil? ? ENV.delete(key) : ENV[key] = original_value
  end

  before { travel_to(Time.zone.local(2026, 11, 7, 12)) }

  def create_visits_around(cutoff)
    [cutoff - 1.second, cutoff, cutoff + 1.second].map do |timestamp|
      Renalware::System::Visit.create!(started_at: timestamp)
    end
  end

  def create_events_for(visits)
    visits.map do |visit|
      Renalware::System::Event.create!(visit:, time: visit.started_at)
    end
  end

  shared_examples "retaining audit data" do |setting, months|
    it "retains records on and after the cutoff for #{setting.inspect}" do
      ENV["SYSTEM_VISITS_AND_EVENTS_RETENTION_PERIOD"] = setting if setting
      cutoff = months.months.ago
      visits = create_visits_around(cutoff)
      events = create_events_for(visits)

      described_class.new.call

      expect(Renalware::System::Visit.where(id: visits.map(&:id)).pluck(:id))
        .to match_array(visits.drop(1).map(&:id))
      expect(Renalware::System::Event.where(id: events.map(&:id)).pluck(:id))
        .to match_array(events.drop(1).map(&:id))
    end
  end

  it_behaves_like "retaining audit data", nil, 12
  it_behaves_like "retaining audit data", "P18M", 18
  it_behaves_like "retaining audit data", "P1Y", 12
  it_behaves_like "retaining audit data", "P6M", 6
  it_behaves_like "retaining audit data", "P3M", 6
  it_behaves_like "retaining audit data", "P0D", 6
  it_behaves_like "retaining audit data", "-P1M", 6
  it_behaves_like "retaining audit data", "P183D", 6

  it "does not delete audit data when the duration is invalid" do
    ENV["SYSTEM_VISITS_AND_EVENTS_RETENTION_PERIOD"] = "invalid"
    visit = Renalware::System::Visit.create!(started_at: 2.years.ago)
    event = Renalware::System::Event.create!(visit:, time: 2.years.ago)

    expect { described_class.new.call }
      .to raise_error(ActiveSupport::Duration::ISO8601Parser::ParsingError)

    expect(Renalware::System::Visit.exists?(visit.id)).to be(true)
    expect(Renalware::System::Event.exists?(event.id)).to be(true)
  end

  it "does not delete audit data when the duration is blank" do
    ENV["SYSTEM_VISITS_AND_EVENTS_RETENTION_PERIOD"] = ""
    visit = Renalware::System::Visit.create!(started_at: 2.years.ago)
    event = Renalware::System::Event.create!(visit:, time: 2.years.ago)

    expect { described_class.new.call }
      .to raise_error(ActiveSupport::Duration::ISO8601Parser::ParsingError)

    expect(Renalware::System::Visit.exists?(visit.id)).to be(true)
    expect(Renalware::System::Event.exists?(event.id)).to be(true)
  end
end
