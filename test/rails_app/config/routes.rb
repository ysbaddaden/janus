RailsApp::Application.routes.draw do
  janus :users,
    :session      => true,
    :registration => true,
    :confirmation => true,
    :password     => true

  resource :user, :only => :show
  resource :blog, :only => :show

  root :to => 'home#index'
end
