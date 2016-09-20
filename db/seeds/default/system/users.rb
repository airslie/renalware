module Renalware
  log "Adding System User"

  Renalware::User.create!(
    given_name: "System",
    family_name: "User",
    username: Renalware::SystemUser.username,
    password: SecureRandom.hex(32),
    email: "systemuser@renalware.net",
    approved: true,
    signature: "System User"
  )
end
