class RemoteToken < ActiveRecord::Base
  include Janus::Models::RemoteToken

  belongs_to :user
  validates_presence_of :user
end
