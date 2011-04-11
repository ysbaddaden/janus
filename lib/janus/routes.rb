module ActionDispatch # :nodoc:
  module Routing # :nodoc:
    class Mapper
      # Creates the routes for a Janus capable resource.
      # 
      # Example:
      # 
      #   MyApp::Application.routes.draw do
      #     janus :users, :session => true, :registration => false
      #   end
      # 
      # Options:
      # 
      # - +session+      - true to generate session routes
      # - +registration+ - true to generate registration routes
      # - +confirmation+ - true to generate confirmation routes
      # - +password+     - true to generate password reset routes
      # 
      # Generated session routes:
      # 
      #       new_user_session GET    /users/sign_in(.:format)  {:controller=>"users/sessions", :action=>"new"}
      #           user_session POST   /users/sign_in(.:format)  {:controller=>"users/sessions", :action=>"create"}
      #   destroy_user_session        /users/sign_out(.:format) {:controller=>"users/sessions", :action=>"destroy"}
      # 
      # Generated registration routes:
      # 
      #    new_user_registration GET    /users/sign_up(.:format)  {:controller=>"users/registrations", :action=>"new"}
      #        user_registration POST   /users(.:format)          {:controller=>"users/registrations", :action=>"create"}
      #   edit_user_registration GET    /users/edit(.:format)     {:controller=>"users/registrations", :action=>"edit"}
      #                          PUT    /users(.:format)          {:controller=>"users/registrations", :action=>"update"}
      #                          DELETE /users(.:format)          {:controller=>"users/registrations", :action=>"destroy"}
      # 
      # Generated confirmation routes:
      # 
      #       user_confirmation POST   /users/confirmation(.:format)     {:controller=>"users/confirmations", :action=>"create"}
      #   new_user_confirmation GET    /users/confirmation/new(.:format) {:controller=>"users/confirmations", :action=>"new"}
      #                         GET    /users/confirmation(.:format)     {:controller=>"users/confirmations", :action=>"show"}
      # 
      # Generated password reset routes:
      # 
      #        user_password POST   /users/password(.:format)      {:controller=>"users/passwords", :action=>"create"}
      #    new_user_password GET    /users/password/new(.:format)  {:controller=>"users/passwords", :action=>"new"}
      #   edit_user_password GET    /users/password/edit(.:format) {:controller=>"users/passwords", :action=>"edit"}
      #                      PUT    /users/password(.:format)      {:controller=>"users/passwords", :action=>"update"}
      #                      DELETE /users/password(.:format)      {:controller=>"users/passwords", :action=>"destroy"}
      # 
      def janus(*resources)
        ActionController::Base.send(:include, Janus::Helpers) unless ActionController::Base.include?(Janus::Helpers)
        options = resources.extract_options!
        
        resources.each do |plural|
          singular = plural.to_s.singularize
          
          if options[:session]
            scope :path => plural, :controller => "#{plural}/sessions" do
              match "/sign_in(.:format)", :action => "new", :via => :get, :as => "new_#{singular}_session"
              match "/sign_in(.:format)", :action => "create", :via => :post, :as => "#{singular}_session"
              match "/sign_out(.:format)", :action => "destroy",  :as => "destroy_#{singular}_session"
            end
          end
          
          namespace plural, :as => singular do
            if options[:registration]
              resource :registration, :except => [:index, :show], :path => "",
                :path_names => { :new => 'sign_up' }
            end
            
            resource :confirmation, :only => [:show, :new, :create] if options[:confirmation]
            resource :password, :except => [:index, :show] if options[:password]
          end
          
          ActionController::Base.janus(singular)
        end
      end
    end
  end
end
