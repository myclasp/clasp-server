Rails.application.routes.draw do
  
  get 'pages/home'
  post 'moments', to: 'moments#create', as: :moments

end
