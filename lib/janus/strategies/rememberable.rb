#module Janus
#  module Strategies
#    class Base
#      protected
#        def remember_cookie_name
#          "remember_#{scope}_token"
#        end

#        def remember_cookie
#          request.cookies[remember_cookie_name]
#        end

#        # True by default, may be set to false by specific strategies to turn
#        # off the remember me feature --for instance on token based authentication.
#        def remember_me?
#          true
#        end

#        # Checks wether the user is rememberable or not.
#        def rememberable?
#          resource.include?(Janus::Models::Rememberable)
#        end

#        def success_with_remember!(user) # :nodoc:
#          if rememberable? && remember_me?
#            user.remember_me!
#            request.cookies[remember_cookie_name] = user.remember_token
#          end
#        end

#        alias_method_chain :success!, :remember
#    end

#    class Rememberable < Base
#      def valid?
#        rememberable? && !remember_cookie.nil?
#      end

#      def authenticate!
#        user = resource.find_for_remember_authentication(remember_cookie)
#        
#        if user.nil?
#          destroy_remember_cookie
#          pass
#        else
#          success!(user)
#        end
#      end

#      private
#        def destroy_remember_cookie
#          request.cookies.delete(remember_cookie_name)
#        end
#    end
#  end
#end
