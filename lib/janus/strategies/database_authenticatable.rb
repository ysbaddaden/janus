#module Janus
#  module Strategies
#    class DatabaseAuthenticatable < Base
#      def valid?
#        if params[scope].blank? ||
#          false
#        else
#          keys = resource.authentication_keys
#          keys << :password
#          keys.each { |key| return false if request.params[scope][key].blank? }
#          true
#        end
#      end

#      def authenticate!
#        if params[]
#      end
#    end
#  end
#end
