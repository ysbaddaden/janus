Janus.config do |config|
  config.contact_email = "contact@some-example-domain.com"

  # DatabaseAuthenticatable
  config.authentication_keys = [ :email ]

  # bcrypt:
  config.encryptor = :bcrypt
  config.stretches = Rails.env.test? ? 1 : 10
  config.pepper = <%= SecureRandom.hex(64).inspect %>

  # scrypt:
  # config.encryptor = :scrypt
  # config.scrypt_options = { :max_time => 0.25 }

  # Confirmable
  # config.confirmation_key = :confirm_token

  # Rememberable
  # config.remember_for = 1.year
  # config.extend_remember_period = false

  # RemoteAuthenticatable
  # config.remote_authentication_key = :remote_token

  # TokenAuthenticatable
  # config.token_authentication_key = :auth_token
end
