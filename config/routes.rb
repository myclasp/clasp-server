Rails.application.routes.draw do
  
  devise_for :users
  
  scope 'v1' do
    post 'auth_user', to: 'authentication#authenticate_user'
    post 'users', to: 'signup#create_user'
    post '/users/:user_id/moments', to: 'moments#create', as: :v1_user_moments
  end

  get 'moments', to: 'moments#index', as: :moments

  get '/pages/home', as: :pages_home
  root to: 'pages#home'
  
end
