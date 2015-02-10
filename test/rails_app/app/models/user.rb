class User < ActiveRecord::Base
  include Janus::Models::DatabaseAuthenticatable
  include Janus::Models::LegacyPasswordAuthenticatable
  include Janus::Models::Confirmable
  include Janus::Models::Rememberable
  include Janus::Models::RemoteAuthenticatable
  include Janus::Models::TokenAuthenticatable
  include Janus::Models::Trackable

  def valid_legacy_password?(password)
    digest_legacy_password(password) === encrypted_legacy_password
  end

  # NOTE: illustration purpose only! Use PBKDF2, bcrypt or scrypt instead!
  def digest_legacy_password(password)
    (Digest::SHA2.new(256) << "#{password}2b42100dc83718d6faff758c").to_s
  end
end
