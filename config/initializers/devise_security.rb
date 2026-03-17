Devise.setup do |config|
  # ==> Security Extension
  # Configure security extension for devise

  # Should the password expire (e.g 3.months)
  config.expire_password_after = 365.days

  # Need 1 char of A-Z, a-z and 0-9
  config.password_complexity = { digit: 0, lower: 0, symbol: 0, upper: 0 }

  # How many passwords to keep in archive
  config.password_archiving_count = 4

  # Deny old passwords (true, false, number_of_old_passwords_to_check)
  config.deny_old_passwords = 4 # will deny new passwords that matches with the last 4 passwords

  # enable email validation for :secure_validatable. (true, false, validation_options)
  # dependency: see https://github.com/devise-security/devise-security/blob/master/README.md#e-mail-validation
  # config.email_validation = true

  # captcha integration for recover form
  # config.captcha_for_recover = true

  # captcha integration for sign up form
  # config.captcha_for_sign_up = true

  # captcha integration for sign in form
  # config.captcha_for_sign_in = true

  # captcha integration for unlock form
  # config.captcha_for_unlock = true

  # captcha integration for confirmation form
  # config.captcha_for_confirmation = true

  # Time period for account expiry from last_activity_at
  config.expire_after = Renalware.config.users_expire_after.days
end
