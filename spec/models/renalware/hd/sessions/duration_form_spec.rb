# frozen_string_literal: true

describe Renalware::HD::Sessions::DurationForm do
  it { is_expected.to validate_presence_of(:start_date) }
  it { is_expected.to validate_timeliness_of(:start_date) }
  it { is_expected.to validate_timeliness_of(:start_time) }
  it { is_expected.to validate_timeliness_of(:end_time) }

  describe ".duration_form_for" do
    it "creates a new form object from a session model" do
      [
        {
          started_at: Time.zone.parse("2001-01-02 00:00"),
          stopped_at: nil,
          expected: {
            start_date: "2001-01-02",
            start_time: nil,
            end_time: nil,
            overnight_dialysis: false
          }
        },
        {
          started_at: Time.zone.parse("2001-01-02 11:00"),
          stopped_at: nil,
          expected: {
            start_date: "2001-01-02",
            start_time: "11:00",
            end_time: nil,
            overnight_dialysis: false
          }
        },
        {
          started_at: Time.zone.parse("2001-01-02 11:00"),
          stopped_at: Time.zone.parse("2001-01-02 13:00"),
          expected: {
            start_date: "2001-01-02",
            start_time: "11:00",
            end_time: "13:00",
            overnight_dialysis: false
          }
        },
        {
          started_at: Time.zone.parse("2001-01-02 23:00"),
          stopped_at: Time.zone.parse("2001-01-03 02:00"),
          expected: {
            start_date: "2001-01-02",
            start_time: "23:00",
            end_time: "02:00",
            overnight_dialysis: true
          }
        }
      ].each do |options|
        form = described_class.duration_form_for(
          instance_double(
            Renalware::HD::Session,
            started_at: options[:started_at],
            stopped_at: options[:stopped_at]
          )
        )
        expect(form.start_date).to eq(Date.parse(options[:expected][:start_date]))
        expect(form.start_time&.strftime("%H:%M")).to eq(options[:expected][:start_time])
        expect(form.end_time&.strftime("%H:%M")).to eq(options[:expected][:end_time])
        expect(form.overnight_dialysis).to eq(options[:expected][:overnight_dialysis])
      end
    end

    context "when the session is new and has no duration" do
      it "silently uses nulls" do
        session = instance_double(
          Renalware::HD::Session,
          started_at: nil,
          stopped_at: nil
        )

        form = described_class.duration_form_for(session)

        expect(form).to have_attributes(
          start_date: nil,
          start_time: nil,
          end_time: nil,
          overnight_dialysis: false
        )
      end
    end
  end

  describe "#validation" do
    context "when start_date present but start_time blank" do
      subject { described_class.new(start_date: "2021-12-12") }

      it { is_expected.to be_valid }
    end

    context "when require_all_fields is true and all fields are no supplied" do
      subject {
        described_class.new(
          require_all_fields: true,
          start_date: "2021-12-12",
          start_time: nil,
          end_time: nil
        ).tap(&:valid?).errors.full_messages
      }

      it { is_expected.to include("Start time can't be blank") }
      it { is_expected.to include("End time can't be blank") }
    end

    context "when start_time is after end_time" do
      subject(:form) {
        described_class.new(
          start_date: "2021-12-12",
          start_time: "12:00",
          end_time: "10:00"
        ).tap(&:valid?).errors.full_messages
      }

      it {
        is_expected.to include(
          "End time must be after 'Start time' unless 'Overnight dialysis' is checked"
        )
      }

      context "when overnight_dialysis is true" do
        subject(:form) {
          described_class.new(
            start_date: "2021-12-12",
            start_time: "12:00",
            end_time: "10:00",
            overnight_dialysis: true
          )
        }

        it do
          expect(form).to be_valid
        end
      end
    end
  end

  describe "#started_at" do
    context "when start_date present but start_time blank" do
      subject { described_class.new(start_date: "2021-12-12").started_at }

      it { is_expected.to eq(Time.zone.parse("2021-12-12 00:00:00")) }
    end

    context "when start_date is not a valid date" do
      subject { described_class.new(start_date: "2021122").started_at }

      it { is_expected.to be_nil }
    end

    context "when start_date and start_time are present" do
      subject { described_class.new(start_date: "2021-12-12", start_time: "11:31").started_at }

      it { is_expected.to eq(Time.zone.parse("2021-12-12 11:31:00")) }
    end

    context "when allowing for a different server timestamp", tz: "Pacific Time (US & Canada)" do
      subject { described_class.new(start_date: "2021-12-12", start_time: "11:31").started_at }

      it do
        is_expected.to eq(Time.zone.parse("Sun, 12 Dec 2021 11:31:00 -0800"))
      end
    end
  end

  describe "#stopped_at" do
    context "when start_date present but start_time and end_time are blank" do
      subject { described_class.new(start_date: "2021-12-12").stopped_at }

      it { is_expected.to be_nil }
    end

    context "when start_date and start_time present but end_time is blank" do
      subject { described_class.new(start_date: "2021-12-12", start_time: "11:31").stopped_at }

      it { is_expected.to be_nil }
    end

    context "when start_date, start_time and end_time are present" do
      subject do
        described_class.new(
          start_date: "2021-12-12",
          start_time: "11:31",
          end_time: "13:31"
        ).stopped_at
      end

      it { is_expected.to eq(Time.zone.parse("2021-12-12 13:31:00")) }

      context "when overnight_dialysis is true" do
        subject(:form) do
          described_class.new(
            start_date: "2021-12-12",
            start_time: "22:31",
            end_time: "01:01",
            overnight_dialysis: true
          )
        end

        it do
          expect(form).to be_valid
          expect(form.stopped_at).to eq(Time.zone.parse("2021-12-13 01:01:00"))
        end
      end

      context "when allowing for a different server timestamp", tz: "Pacific Time (US & Canada)" do
        subject do
          described_class.new(
            start_date: "2021-12-12",
            start_time: "11:31",
            end_time: "13:31"
          ).stopped_at
        end

        it { is_expected.to eq(Time.zone.parse("Sun, 12 Dec 2021 13:31:00 -0800")) }
      end
    end
  end
end
