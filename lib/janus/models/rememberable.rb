#module Janus
#  module Models
#    module Rememberable
#      extend ActiveSupport::Concern

#      def forget_me!
#        update_attribute(:remember_token, nil) unless remember_token.nil?
#      end

#      def remember_me!
#        loop do
#          self.remember_token = ActiveSupport::SecureRandom.hex(64)
#          break unless self.class.find_for_remember_authentication(remember_token)
#        end
#        
#        update_attribute(:remember_token, remember_token)
#      end

#      module ClassMethods
#        def find_for_remember_authentication(token)
#          where(:remember_token => token).first
#        end
#      end
#    end
#  end
#end
