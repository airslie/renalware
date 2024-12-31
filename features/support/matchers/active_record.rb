RSpec::Matchers.define :be_modified do
  match do |record|
    record.reload
    record.created_at != record.updated_at
  end
end
