Rails.application.routes.draw do
  get 'waiting_room/index'
  get 'lobby/index'
  post '/lobby/create', to: 'lobby#create', as: 'lobby_create'
  post '/lobby/login', to: 'lobby#login', as: 'lobby_login'
  post '/waiting_room_controller/exit_waiting_list', to: 'waiting_room#exit_waiting_list'
  get '/clear_waiting_list', to: 'waiting_room#clear_waiting_list'

  get 'waiting_room', to: 'waiting_room#index'

  root 'lobby#index'
end
