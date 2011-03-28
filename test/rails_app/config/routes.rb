RailsApp::Application.routes.draw do
  janus :users, :session => true, :registration => true
  
  resource :user, :only => :show
  root :to => 'home#index'
end
