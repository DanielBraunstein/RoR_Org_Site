Rails.application.routes.draw do
  root 'users#main'
  post 'users/login' => 'users#login'
  get 'users/logout' => 'users#logout'
  post 'users/create' => 'users#create'
  get 'groups/:group_id' => 'groups#show_one'
  post 'groups/create' => 'groups#create'
  post 'groups/join/:group_id' => 'groups#join'
  post 'groups/leave/:group_id' => 'groups#leave'
  post 'groups/destroy/:group_id' => 'groups#destroy'
  get 'groups/' => 'groups#main'
end