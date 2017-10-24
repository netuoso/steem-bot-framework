Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users

  get :index, controller: :bots, action: :index
  get :logout, controller: :home, action: :logout
  get :parse_url, controller: :bots, action: :parse_url
  post :perform_action, controller: :bots, action: :perform_action

  root controller: :bots, action: :index
end
