Rails.application.routes.draw do
  get 'waiting_room/index'
  get 'lobby/index'
  get '/game_sessions/:id', to: 'game_sessions#show', as: 'game_session'
  get 'waiting_room', to: 'waiting_room#index'
  get '/poll_game_session_status', to: 'admin/game#poll_game_session_status', as: 'poll_game_session_status'

  post '/lobby/create', to: 'lobby#create', as: 'lobby_create'
  post '/lobby/login', to: 'lobby#login', as: 'lobby_login'
  post '/waiting_room/exit_waiting_list', to: 'waiting_room#exit_waiting_list', as: 'exit_waiting_list'

  root 'lobby#index'

  namespace :admin do
    constraints(->(request) { request.session[:user_id] && User.find(request.session[:user_id]).admin? }) do
      resources :game, only: [:index] do
        post :start_game_session, on: :collection
        get :clear_waiting_list, on: :collection
        # get :clear_game_session on: :collection
      end
    end
  end

  resources :game_sessions, only: [:show] do
    get :clear_game_session, on: :member
    get :questions_separator, on: :member
  end
end
