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
      # - +password+     - true to generate password reset routes
      # 
      # Generated session routes:
      # 
      #       new_user_session GET    /users/sign_in(.:format)  {:action=>"new",     :controller=>"users/sessions"}
      #           user_session POST   /users/sign_in(.:format)  {:action=>"create",  :controller=>"users/sessions"}
      #   destroy_user_session        /users/sign_out(.:format) {:action=>"destroy", :controller=>"users/sessions"}
      # 
      # Generated registration routes:
      # 
      #    new_user_registration GET    /users/sign_up(.:format)  {:action=>"new",     :controller=>"users/registrations"}
      #        user_registration POST   /users(.:format)          {:action=>"create",  :controller=>"users/registrations"}
      #   edit_user_registration GET    /users/edit(.:format)     {:action=>"edit",    :controller=>"users/registrations"}
      #                          PUT    /users(.:format)          {:action=>"update",  :controller=>"users/registrations"}
      #                          DELETE /users(.:format)          {:action=>"destroy", :controller=>"users/registrations"}
      # 
      # Generated password reset routes:
      # 
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
          
          if options[:registration]
            resource plural, :except => [:index, :show], :as => "#{singular}_registration",
              :controller => "#{plural}/registrations", :path_names => { :new => 'sign_up' }
          end
          
          namespace plural, :as => singular do
            resource :password, :except => [:index, :show] if options[:password]
          end
          
          ActionController::Base.janus(singular)
        end
      end
    end
  end
end
