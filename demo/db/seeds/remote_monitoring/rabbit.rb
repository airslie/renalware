module Renalware
  class CreateRemoteMonitoringRegistration
    def initialize
      @rabbit = Patient.find_by(family_name: "RABBIT", given_name: "Roger")
      @event_type = Events::Type.find_by!(name: "Remote Monitoring Registration")
      @user_id = User.first.id
    end

    def call(on: 1.day.ago, reason: nil, frequency: nil) # rubocop:disable Metrics/MethodLength
      reason ||= RemoteMonitoring::ReferralReason.first.description
      frequency ||= RemoteMonitoring::Frequency.first.period.iso8601
      RemoteMonitoring::Registration.new(
        patient_id: @rabbit.id,
        event_type_id: @event_type.id,
        notes: Faker::Lorem.sentence,
        date_time: on,
        created_at: on,
        updated_at: on,
        created_by_id: @user_id,
        updated_by_id: @user_id,
        document: {
          referral_reason: reason,
          frequency_iso8601: frequency,
          baseline_creatinine: 55.1
        }
      ).save!
    end
  end

  Rails.benchmark "Adding Remote Monitoring Registration events for Roger Rabbit" do
    CreateRemoteMonitoringRegistration.new.call
  end
end
