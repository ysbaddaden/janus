require 'janus/hooks/remote_authenticatable'

module Janus
  module Models
    # = RemoteAuthenticatable
    # 
    # Keeping a user connected on subdomains is an easy task, all you need to do
    # is define the session cookie to <tt>.example.com</tt> for instance. But
    # keeping a user connected on multiple top level domains is a harder task.
    # 
    # Hopefully RemoteAuthenticatable takes care of all the hassle.
    # 
    # == Single Sign In
    # 
    # The authentication must happen on a single domain, for instance
    # <tt>login.example.com</tt>, then other domains must redirect to that
    # domain's new session url. For instance:
    # 
    #   redirect_to new_user_session_url(:host => "login.example.com") unless user_signed_in?
    # 
    # And that's it! The user shall be redirected with an unique +remote_token+,
    # which shall log her in. Actually the user won't be logged in through
    # Janus::Manager#login but through Janus::Manager#set_user which won't
    # run the login hooks. This is useful for not tracking the user everytime
    # it gets authenticated on each remote site.
    # 
    # == Single Sign Out
    # 
    # Session state is maintained across domains through the session_token
    # column of your User model. If a session token is invalid the session
    # is simply resetted, thus logging out the user on remote domains. Actually
    # the user is logged out using Janus::Manager#unset_user before
    # resetting the session.
    # 
    # == Required columns and models:
    # 
    # A +session_token+ column (string) is required, as well as a RemoteToken
    # model like so:
    # 
    #   class RemoteToken < ActiveRecord::Base
    #     include Janus::Models::RemoteToken
    #   
    #     belongs_to :user
    #     validates_presence_of :user
    #   end
    # 
    # With the associated table:
    # 
    #   create_table :remote_tokens do |t|
    #     t.references :user
    #     t.string     :token
    #     t.datetime   :created_at
    #   end
    #   
    #   add_index :remote_tokens, :token, :unique => true
    module RemoteAuthenticatable
      extend ActiveSupport::Concern

      included do |klass|
        attr_protected :session_token
        klass.class_eval { has_many :remote_tokens }
        janus_config :remote_authentication_key
      end

      # Generates an unique session token. This token will be used to validate
      # the current session, and must be generated whenever a user signs in on
      # the main site.
      # 
      # The token won't be regenerated if it already exists.
      def generate_session_token!
        update_attribute(:session_token, self.class.generate_token(:session_token)) unless session_token
        session_token
      end

      # Destroys the session token. This must be called whenever the user signs
      # out. Doing so will invalidate all sessions using this token at once
      # --hence single sign out.
      def destroy_session_token!
        update_attribute(:session_token, nil)
      end

      # Returns a temporary token to be used with find_for_remote_authentication.
      def generate_remote_token!
        remote_tokens.create.token
      end

      module ClassMethods
        def find_for_remote_authentication(token)
          remote_token = ::RemoteToken.where(:token => token).first
          
          if remote_token
            remote_token.destroy
            remote_token.user unless remote_token.created_at < 30.seconds.ago
          end
        end
      end
    end
  end
end
