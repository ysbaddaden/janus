class User < ActiveRecord::Base
  include Janus::Models::DatabaseAuthenticatable
end
