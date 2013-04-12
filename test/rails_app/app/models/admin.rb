class Admin < ActiveRecord::Base
  include Janus::Models::DatabaseAuthenticatable
end
