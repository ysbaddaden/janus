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
      def janus(*resources)
        ApplicationController.send(:include, Janus::Helpers) unless ApplicationController.include?(Janus::Helpers)
        options = resources.extract_options!
        
        resources.each do |plural|
          singular = plural.to_s.singularize
          
          if options[:session]
            match "/#{plural}/sign_in(.:format)"  => "#{plural}/sessions#new",
              :via => :get, :as => "new_#{singular}_session"
            
            match "/#{plural}/sign_in(.:format)"  => "#{plural}/sessions#create",
              :via => :post, :as => "#{singular}_session"
            
            match "/#{plural}/sign_out(.:format)" => "#{plural}/sessions#destroy",
              :as => "destroy_#{singular}_session"
          end
          
          if options[:registration]
            resource plural, :except => [:index, :show], :as => "#{singular}_registration",
              :controller => "#{plural}/registrations", :path_names => { :new => 'sign_up' }
          end
          
          ApplicationController.janus(singular)
        end
      end
    end
  end
end
