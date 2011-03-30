class User < ActiveRecord::Base
  include Janus::Models::DatabaseAuthenticatable
#  include Janus::Models::Rememberable
end
