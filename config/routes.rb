Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post '/teams', to: 'teams#create'

  post '/auth', to: 'auth#create'
  get '/auth', to: 'auth#show'
end
