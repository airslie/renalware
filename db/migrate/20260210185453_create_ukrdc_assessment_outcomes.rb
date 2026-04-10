class CreateUKRDCAssessmentOutcomes < ActiveRecord::Migration[8.0]
  def change
    within_renalware_schema do
      create_table :ukrdc_assessment_outcomes, id: false do |t|
        t.integer :code, null: false, primary_key: true
        t.string :description
        t.references(
          :assessment_type,
          null: false,
          foreign_key: { to_table: :ukrdc_assessment_types }
        )
        t.timestamps default: -> { "CURRENT_TIMESTAMP" }
      end

      execute <<~SQL
        INSERT INTO renalware.ukrdc_assessment_outcomes (description, assessment_type_id, created_at, updated_at) VALUES('Opts for supportive care', 2, current_timestamp, current_timestamp) on conflict do nothing;
        INSERT INTO renalware.ukrdc_assessment_outcomes (description, assessment_type_id, created_at, updated_at) VALUES('Current home', 3, current_timestamp, current_timestamp) on conflict do nothing;
        INSERT INTO renalware.ukrdc_assessment_outcomes (description, assessment_type_id, created_at, updated_at) VALUES('Nursing home', 3, current_timestamp, current_timestamp) on conflict do nothing;
        INSERT INTO renalware.ukrdc_assessment_outcomes (description, assessment_type_id, created_at, updated_at) VALUES('Hospice', 3, current_timestamp, current_timestamp) on conflict do nothing;
        INSERT INTO renalware.ukrdc_assessment_outcomes (description, assessment_type_id, created_at, updated_at) VALUES('Hospital', 3, current_timestamp, current_timestamp) on conflict do nothing;
        INSERT INTO renalware.ukrdc_assessment_outcomes (description, assessment_type_id, created_at, updated_at) VALUES('Other', 3, current_timestamp, current_timestamp) on conflict do nothing;
        INSERT INTO renalware.ukrdc_assessment_outcomes (description, assessment_type_id, created_at, updated_at) VALUES('Unsuitable', 1, current_timestamp, current_timestamp) on conflict do nothing;
        INSERT INTO renalware.ukrdc_assessment_outcomes (description, assessment_type_id, created_at, updated_at) VALUES('Workup commenced', 1, current_timestamp, current_timestamp) on conflict do nothing;
        INSERT INTO renalware.ukrdc_assessment_outcomes (description, assessment_type_id, created_at, updated_at) VALUES('Suitable', 1, current_timestamp, current_timestamp) on conflict do nothing;
        INSERT INTO renalware.ukrdc_assessment_outcomes (description, assessment_type_id, created_at, updated_at) VALUES('Referred for assessment', 2, current_timestamp, current_timestamp) on conflict do nothing;
        INSERT INTO renalware.ukrdc_assessment_outcomes (description, assessment_type_id, created_at, updated_at) VALUES('Assessment in progress', 2, current_timestamp, current_timestamp) on conflict do nothing;
        INSERT INTO renalware.ukrdc_assessment_outcomes (description, assessment_type_id, created_at, updated_at) VALUES('Opts for transplant', 2, current_timestamp, current_timestamp) on conflict do nothing;
        INSERT INTO renalware.ukrdc_assessment_outcomes (description, assessment_type_id, created_at, updated_at) VALUES('Opts for ICHD', 2, current_timestamp, current_timestamp) on conflict do nothing;
        INSERT INTO renalware.ukrdc_assessment_outcomes (description, assessment_type_id, created_at, updated_at) VALUES('Opts for HHD', 2, current_timestamp, current_timestamp) on conflict do nothing;
        INSERT INTO renalware.ukrdc_assessment_outcomes (description, assessment_type_id, created_at, updated_at) VALUES('Opts for PD', 2, current_timestamp, current_timestamp) on conflict do nothing;
      SQL
    end
  end
end
