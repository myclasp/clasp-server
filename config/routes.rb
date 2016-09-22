Rails.application.routes.draw do
  
  devise_for :users
  post 'auth_user', to: 'authentication#authenticate_user'
  root to: 'pages#home'
  post 'moments', to: 'moments#create', as: :moments
  
end
