class User < ActiveRecord::Base
  include Janus::Models::Base
  include Janus::Models::DatabaseAuthenticatable
  include Janus::Models::RemoteAuthenticatable
end
