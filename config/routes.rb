Rails.application.routes.draw do

  devise_for :users
  
  scope 'v1' do
    post 'auth_user', to: 'authentication#authenticate_user'
    post 'users', to: 'signup#create_user'
    post '/users/:user_id/moments', to: 'moments#create', as: :v1_user_moments
    get '/users/:user_id/moments', to: 'moments#v1_user_moments', as: :v1_select_user_moments
    get '/groups/:group_id/moments', to: 'moments#v1_group_moments', as: :v1_select_group_moments
  end

  get 'moments', to: 'moments#index', as: :moments
  get 'groups/:id', to: 'groups#show', as: :group 
  get 'groups/:id/edit', to: 'groups#edit', as: :edit_group 

  get '/pages/home', as: :pages_home
  root to: 'pages#home'
  
end
