Janus.config do |config|
  config.contact_email = "contact@some-example-domain.com"

  # DatabaseAuthenticatable
  config.authentication_keys = [ :email ]
  config.encryptor = :bcrypt
  config.stretches = 10
  config.pepper = "db5ef161873f4b4cd966ff042c448282e8243a0a4e090347370360796ecc769f384d898badda1881bc7ed4483f20f6809b39a54f6671cc35cda18bfe554cd8e0"
  # config.scrypt_options = { :max_time => 0.25 }

  # Confirmable
  # config.confirmation_key = :confirm_token

  # Rememberable
  # config.remember_for = 1.year
  # config.extend_remember_period = false

  # RemoteAuthenticatable
  # config.remote_authentication_key = :auth_token
end
