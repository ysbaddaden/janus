RailsApp::Application.routes.draw do
  janus :users, :controllers => [:sessions, :registrations]

#  match '/users/sign_in(.:format)'  => 'users/sessions#new',          :via => :get,  :as => 'new_user_session'
#  match '/users/sign_in(.:format)'  => 'users/sessions#create',       :via => :post, :as => 'user_session'
#  match '/users/sign_out(.:format)' => 'users/sessions#destroy',                     :as => 'destroy_user_session'

#  match '/users/sign_up(.:format)'  => 'users/registrations#new',     :via => :get,  :as => 'new_user_registration'
#  match '/users(.:format)'          => 'users/registrations#create',  :via => :post, :as => 'user_registration'
#  match '/users/edit(.:format)'     => 'users/registrations#edit',    :via => :get,  :as => 'edit_user_registration'
#  match '/users(.:format)'          => 'users/registrations#update',  :via => :put
#  match '/users(.:format)'          => 'users/registrations#destroy', :via => :delete

  resource :user, :only => :show

  root :to => 'home#index'
end
