Rails.application.routes.draw do
  
  devise_for :users
  get 'pages/home'
  post 'moments', to: 'moments#create', as: :moments

end
