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

      safety_assured do
        execute <<~SQL
          INSERT INTO renalware.ukrdc_assessment_outcomes (code, description, assessment_type_id, created_at, updated_at) VALUES(1, 'Unsuitable', 1, current_timestamp, current_timestamp) on conflict do nothing;
          INSERT INTO renalware.ukrdc_assessment_outcomes (code, description, assessment_type_id, created_at, updated_at) VALUES(2, 'Workup commenced', 1, current_timestamp, current_timestamp) on conflict do nothing;
          INSERT INTO renalware.ukrdc_assessment_outcomes (code, description, assessment_type_id, created_at, updated_at) VALUES(3, 'Suitable', 1, current_timestamp, current_timestamp) on conflict do nothing;
          INSERT INTO renalware.ukrdc_assessment_outcomes (code, description, assessment_type_id, created_at, updated_at) VALUES(4, 'Referred for assessment', 2, current_timestamp, current_timestamp) on conflict do nothing;
          INSERT INTO renalware.ukrdc_assessment_outcomes (code, description, assessment_type_id, created_at, updated_at) VALUES(5, 'Assessment in progress', 2, current_timestamp, current_timestamp) on conflict do nothing;
          INSERT INTO renalware.ukrdc_assessment_outcomes (code, description, assessment_type_id, created_at, updated_at) VALUES(6, 'Opts for transplant', 2, current_timestamp, current_timestamp) on conflict do nothing;
          INSERT INTO renalware.ukrdc_assessment_outcomes (code, description, assessment_type_id, created_at, updated_at) VALUES(7, 'Opts for ICHD', 2, current_timestamp, current_timestamp) on conflict do nothing;
          INSERT INTO renalware.ukrdc_assessment_outcomes (code, description, assessment_type_id, created_at, updated_at) VALUES(8, 'Opts for HHD', 2, current_timestamp, current_timestamp) on conflict do nothing;
          INSERT INTO renalware.ukrdc_assessment_outcomes (code, description, assessment_type_id, created_at, updated_at) VALUES(9, 'Opts for PD', 2, current_timestamp, current_timestamp) on conflict do nothing;
          INSERT INTO renalware.ukrdc_assessment_outcomes (code, description, assessment_type_id, created_at, updated_at) VALUES(10, 'Opts for supportive care', 2, current_timestamp, current_timestamp) on conflict do nothing;
          INSERT INTO renalware.ukrdc_assessment_outcomes (code, description, assessment_type_id, created_at, updated_at) VALUES(11, 'Current home', 3, current_timestamp, current_timestamp) on conflict do nothing;
          INSERT INTO renalware.ukrdc_assessment_outcomes (code, description, assessment_type_id, created_at, updated_at) VALUES(12, 'Nursing home', 3, current_timestamp, current_timestamp) on conflict do nothing;
          INSERT INTO renalware.ukrdc_assessment_outcomes (code, description, assessment_type_id, created_at, updated_at) VALUES(13, 'Hospice', 3, current_timestamp, current_timestamp) on conflict do nothing;
          INSERT INTO renalware.ukrdc_assessment_outcomes (code, description, assessment_type_id, created_at, updated_at) VALUES(14, 'Hospital', 3, current_timestamp, current_timestamp) on conflict do nothing;
          INSERT INTO renalware.ukrdc_assessment_outcomes (code, description, assessment_type_id, created_at, updated_at) VALUES(15, 'Other', 3, current_timestamp, current_timestamp) on conflict do nothing;
        SQL
      end
    end
  end
end
