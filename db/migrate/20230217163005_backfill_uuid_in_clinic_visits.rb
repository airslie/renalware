class BackfillUuidInClinicVisits < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def up
    Renalware::Clinics::ClinicVisit.unscoped.in_batches do |relation|
      relation.where(uuid: nil).update_all("uuid = uuid_generate_v4()")
      sleep(0.01)
    end
  end
end
