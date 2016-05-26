module Renalware
  log "--------------------Adding Users--------------------"
  Renalware::User.create!(
    given_name: 'System',
    family_name: 'User',
    username: Renalware::User::SYSTEM_USERNAME,
    password: SecureRandom.hex(32),
    email: 'systemuser@renalware.net',
    approved: true,
    signature: 'System User'
  )
  log "1 User seeded"
end
