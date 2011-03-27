module ActionDispatch::Routing
  class Mapper
    def janus(*resources)
      options = resources.extract_options!
      
      resources.each do |resource|
        singular = resource.to_s.singularize
        
        if options[:controllers].include?(:sessions)
          match "/#{resource}/sign_in(.:format)"  => "#{resource}/sessions#new",          :via => :get,  :as => "new_#{singular}_session"
          match "/#{resource}/sign_in(.:format)"  => "#{resource}/sessions#create",       :via => :post, :as => "#{singular}_session"
          match "/#{resource}/sign_out(.:format)" => "#{resource}/sessions#destroy",                     :as => "destroy_#{singular}_session"
        end
        
        if options[:controllers].include?(:registrations)
          match "/#{resource}/sign_up(.:format)"  => "#{resource}/registrations#new",     :via => :get,  :as => "new_#{singular}_registration"
          match "/#{resource}(.:format)"          => "#{resource}/registrations#create",  :via => :post, :as => "#{singular}_registration"
          match "/#{resource}/edit(.:format)"     => "#{resource}/registrations#edit",    :via => :get,  :as => "edit_#{singular}_registration"
          match "/#{resource}(.:format)"          => "#{resource}/registrations#update",  :via => :put
          match "/#{resource}(.:format)"          => "#{resource}/registrations#destroy", :via => :delete
        end
      end
    end
  end
end
