Rails.application.routes.draw do
  get 'waiting_room/index'
  get 'lobby/index'

  post '/lobby/create', to: 'lobby#create', as: 'lobby_create'
  post '/lobby/login', to: 'lobby#login', as: 'lobby_login'
  post '/waiting_room/exit_waiting_list', to: 'waiting_room#exit_waiting_list'

  namespace :admin do
    constraints(->(request) { request.session[:user_id] && User.find(request.session[:user_id]).admin? }) do
      resources :game, only: [:index] do
        post :start_game_session, on: :collection
        get :clear_waiting_list, on: :collection
      end
    end
  end

  resources :game_sessions, only: [:show]

  get 'waiting_room', to: 'waiting_room#index'
  root 'lobby#index'
end
