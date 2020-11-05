Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post '/teams', to: 'teams#create'

  # LOGIN
  post '/auth', to: 'auth#create'
  # VALIDATE TOKEN
  get '/auth', to: 'auth#show'

  post '/teams/:id/rosters', to: 'rosters#create'
end
