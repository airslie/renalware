module Renalware
  # Rails.benchmark "Adding HD Diaries" do
  class CreateDiary
    attr_reader :unit, :user

    def initialize(unit, user)
      @unit = unit
      @user = user
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def call
      HD::Scheduling::DiarySlot.delete_all
      HD::Scheduling::Diary.delete_all

      # Build master diary
      master = HD::Scheduling::MasterDiary.find_or_initialize_by(
        hospital_unit_id: unit.id
      ) do |diary|
        diary.save_by!(user)
      end

      # Renalware::HD::Patient.all.each do |patient|
      #   schedule= patient&.hd_profile&.schedule_definition
      #   if schedule
      #
      #   else
      #     p "No hd_profile.schedule_definition found for #{patient}"
      #   end
      # end
      #
      # find the schedule for mon wed fri
      # get all patients with that
      # for each day in sechd eg min
      # loop through patients
      #  increment station each time unelss no more stations
      #  create slot
      #
      schedules = Renalware::HD::ScheduleDefinition.all

      schedules.each do |schedule|
        patients = Renalware::HD::Patient
          .joins(:hd_profile)
          .where(hd_profiles: { schedule_definition_id: schedule.id })

        schedule.days.each do |day_of_week|
          station_ids = Renalware::HD::Station.where(hospital_unit_id: unit.id).pluck(:id)
          patients.each do |patient|
            station_id = station_ids.pop
            next if station_id.blank?

            master.slots.create!(patient_id: patient.id,
                                 station_id: station_id,
                                 day_of_week: day_of_week,
                                 diurnal_period_code_id: schedule.diurnal_period_id,
                                 by: user)
          end
        end
      end

      # Add one or two patients to the weekly diary.
      # Choose non-HD patients otherwise they might clash with the above
      patients = Renalware::PD::Patient.take(2)
      diurnal_period_code_ids = HD::DiurnalPeriodCode.pluck(:id)
      station_ids = Renalware::HD::Station.where(hospital_unit_id: unit.id).pluck(:id)

      weekly = HD::Scheduling::WeeklyDiary.find_or_initialize_by(
        hospital_unit_id: unit.id,
        master_diary: master,
        year: 2017,
        week_number: Time.zone.today.cweek
      ) do |diary|
        diary.save_by!(user)
      end

      weekly.slots.create(
        patient_id: patients.first.id,
        station_id: station_ids.pop,
        day_of_week: (1..7).to_a.sample,
        diurnal_period_code_id: diurnal_period_code_ids.sample,
        by: user
      )

      weekly.slots.create(
        patient_id: patients.last.id,
        station_id: station_ids.pop,
        day_of_week: (1..7).to_a.sample,
        diurnal_period_code_id: diurnal_period_code_ids.sample,
        by: user
      )

      # patient_ids = Renalware::HD::Patient.pluck(:id)

      # HD::DiurnalPeriodCode.all.each do |code|
      #   # AM, PM EVE

      #   HD::Station.for_unit(unit).each do |station|
      #     # Station1
      #     used_patient_ids = []

      #     (1..7).each do |day_of_week|
      #       # 1 = Monday

      #       # patient has to be unique for this station/day/period
      #       patient = Renalware::Patient.where.not(id: used_patient_ids).first
      #       next if patient.nil?
      #       used_patient_ids << patient.id

      #       ok = master.slots.create(
      #             patient_id: patient.id,
      #             station: station,
      #             day_of_week: day_of_week,
      #             diurnal_period_code: code,
      #             by: user
      #       )
      #       if ok == false
      #       end
      #     end
      #   end
      # end

      # HD::DiurnalPeriodCode.all.each do |code|
      #   HD::Station.for_unit(unit).each do |station|
      #     used_patient_ids = []
      #     # patient has to be unique for this station/day/period
      #     patient = Renalware::Patient.where.not(id: used_patient_ids).first
      #     next if patient.nil?
      #     used_patient_ids << patient.id
      #     ok = weekly.slots.create(
      #           patient_id: patient.id,
      #           station: station,
      #           day_of_week: (1..7).to_a.sample,
      #           diurnal_period_code: code,
      #           by: user)
      #     if ok == false
      #     end
      #   end
      # end

      # HD::DiurnalPeriodCode.all.each do |code|
      #   period = HD::DiaryPeriod
      #     .find_or_initialize_by(diurnal_period_code: code, diary: master) do |per|
      #     per.save_by!(user)
      #   end
      #   if period.slots.empty?
      #     HD::Station.for_unit(unit).each do |station|
      #       (1..7).each do |day_of_week|
      #         period.slots.create(
      #           patient_id: Patient.first.id,
      #           station: station,
      #           day_of_week: day_of_week,
      #           by: user
      #         )
      #       end
      #     end
      #   end
      # end

      # station = HD::Station.find_or_initialize_by(
      #   name: row["name"],
      #   location: row["location"],
      #   hospital_unit_id: unit.id,
      #   position: row["position"]
      # ).save_by!(user)
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
  end

  CreateDiary.new(Renalware::Hospitals::Unit.first, User.first).call
  # end
end
