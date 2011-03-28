module ActionDispatch::Routing
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
      
      resources.each do |resource|
        singular = resource.to_s.singularize
        
        if options[:session]
          match "/#{resource}/sign_in(.:format)"  => "#{resource}/sessions#new",     :via => :get,  :as => "new_#{singular}_session"
          match "/#{resource}/sign_in(.:format)"  => "#{resource}/sessions#create",  :via => :post, :as => "#{singular}_session"
          match "/#{resource}/sign_out(.:format)" => "#{resource}/sessions#destroy",                :as => "destroy_#{singular}_session"
        end
        
        if options[:registration]
          match "/#{resource}/sign_up(.:format)"  => "#{resource}/registrations#new",     :via => :get,  :as => "new_#{singular}_registration"
          match "/#{resource}(.:format)"          => "#{resource}/registrations#create",  :via => :post, :as => "#{singular}_registration"
          match "/#{resource}/edit(.:format)"     => "#{resource}/registrations#edit",    :via => :get,  :as => "edit_#{singular}_registration"
          match "/#{resource}(.:format)"          => "#{resource}/registrations#update",  :via => :put
          match "/#{resource}(.:format)"          => "#{resource}/registrations#destroy", :via => :delete
        end
        
        ApplicationController.janus(singular)
      end
    end
  end
end
