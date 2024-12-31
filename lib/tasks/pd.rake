namespace :pd do
  desc "Applies the PD Calculations that are normally done when a user saves a regime. " \
       "Useful post-migration to populate calculated fields. " \
       "We avoid changing the updated_at timestamp in this instance, so it is recommended " \
       "to clear the cache after running, otherwise the PD Summary etc in the UI may not update " \
       "because some cache keys are based on the regime.updated_at column."
  # Note if this task fails because the underlying PD regime data is not valid (we call save! so
  # validations run) an alternative is to do this, which you even do in the rails console:
  #   regimes.each { |r| Renalware::PD::APD::CalculateVolumes.new(r).call }
  #   regimes = Renalware::PD::APDRegime.where(daily_volume: nil);
  #   regimes.each { |r| r.update_columns(overnight_volume: r.overnight_volume,
  #     daily_volume: r.daily_volume,
  #     glucose_volume_low_strength: r.glucose_volume_low_strength,
  #     glucose_volume_medium_strength: r.glucose_volume_medium_strength,
  #     glucose_volume_high_strength: r.glucose_volume_high_strength) }
  task apply_calculations: :environment do
    Rails.logger = Logger.new($stdout)
    # Apply to regimes where the calcs have not been run - ie one of the calculated columns is null.
    regimes = Renalware::PD::APDRegime.where(daily_volume: nil).order(created_at: :asc)
    Rails.logger.info "Applying calcs to #{regimes.count} regimes"
    regimes.find_in_batches(batch_size: 50).each do |batch|
      batch.each do |regime|
        Rails.logger.info "Updating regime##{regime.id}"
        regime.save!(touch: false) # don't change updated_at column
      end
    end
  end

  desc "Useful to call this after migrating PET and Adequacy results from the legacy " \
       "pd_pet_adequacies table. It simulates eding a result and saving it in the UI, which " \
       "triggers the calculations to be redone"
  task apply_pet_adequacy_calculations: :environment do
    Rails.logger = Logger.new($stdout)
    Rails.logger.info "Regenerate all PET calcs"
    count = 0
    Renalware::PD::PETResult.find_in_batches(batch_size: 500) do |group|
      count += group.length
      group.each do |pet|
        pet.by = pet.updated_by
        pet.save(validate: false)
      end
    end
    Rails.logger.info "Total PETResults = #{count}"

    Rails.logger.info "Regenerate all Adequacy calcs"
    count = 0
    Renalware::PD::AdequacyResult.find_in_batches(batch_size: 500) do |group|
      count += group.length
      group.each do |adequacy|
        adequacy.by = adequacy.updated_by
        adequacy.save(validate: false)
      end
    end
    Rails.logger.info "Total AdequacyResults = #{count}"
  end
end
