class CreatePathologyRequestDescriptionsRequestsRequests < ActiveRecord::Migration[4.2]
  def change
    create_table :pathology_request_descriptions_requests_requests do |t|
      t.integer :request_id, null: false
      t.integer :request_description_id, null: false
    end

    add_foreign_key :pathology_request_descriptions_requests_requests, :pathology_requests_requests,
                    column: :request_id
    add_foreign_key :pathology_request_descriptions_requests_requests, :pathology_request_descriptions,
                    column: :request_description_id
  end
end
