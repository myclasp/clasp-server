Rails.application.routes.draw do

  get 'admin', to: 'admin#index', as: :admin

  devise_for :users, :controllers => {:registrations => "registrations"}
  
  scope 'v1' do
    post 'auth_user', to: 'authentication#authenticate_user'
    post 'users', to: 'signup#create_user'
    post '/users/:user_id/moments', to: 'moments#create', as: :v1_user_moments
    get '/users/:user_id/moments', to: 'moments#v1_user_moments', as: :v1_select_user_moments
    get '/groups/:group_id/moments', to: 'moments#v1_group_moments', as: :v1_select_group_moments
  end

  get 'moments', to: 'moments#index', as: :moments
  patch 'moments/:id', to: 'moments#update', as: :moment

  post 'moments/:moment_id/features', to: 'features#create', as: :moment_features
  get 'moments/:moment_id/features', to: 'features#show'

  get 'groups/new', to: 'groups#new', as: :new_group
  get 'groups/:id', to: 'groups#show', as: :group
  post 'groups', to: 'groups#create', as: :groups

  post 'groups/:id/users', to: 'groups#add_user', as: :group_add_user 
  get 'groups/:id/edit', to: 'groups#edit', as: :edit_group
  patch 'groups/:id', to: 'groups#update'
  get 'groups/:id/calendar_moments', to: 'groups#calendar_moments', as: :group_calendar_moments
  get 'groups/:id/period_moments', to: 'groups#period_moments', as: :group_period_moments

  patch 'memberships/:id', to: 'memberships#update', as: :membership
  post 'groups/:group_id/memberships', to: 'memberships#create', as: :group_memberships

  get '/pages/home', as: :pages_home
  root to: 'pages#home'
  
end
