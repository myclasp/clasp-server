Rails.application.routes.draw do
  
  devise_for :users
  
  scope 'v1' do
    post 'auth_user', to: 'authentication#authenticate_user'
    post 'users', to: 'signup#create_user'
    post 'moments', to: 'moments#create', as: :moments
  end

  get '/pages/home', as: :pages_home
  root to: 'pages#home'
  
end
