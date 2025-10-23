# frozen_string_literal: true

# Ensure required roles exist before any scenario runs
Before do
  # Create the roles that the User model expects to exist
  Renalware::Role.find_or_create_by(name: :clinical)
  Renalware::Role.find_or_create_by(name: :read_only)
end
