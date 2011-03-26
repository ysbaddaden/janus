RailsApp::Application.routes.draw do
  match '/users/sign_in(.:format)'  => 'users/sessions#new',    :via => :get,  :as => 'new_user_session'
  match '/users/sign_in(.:format)'  => 'users/sessions#create', :via => :post, :as => 'user_session'
  match '/users/sign_out(.:format)' => 'users/sessions#destroy',               :as => 'destroy_user_session'

  resource :user, :only => :show

  root :to => 'home#index'
end
