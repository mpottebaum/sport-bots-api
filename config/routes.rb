Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # TEAM
  post '/teams', to: 'teams#create'

  # LOGIN
  post '/auth', to: 'auth#create'
  # VALIDATE TOKEN
  get '/auth', to: 'auth#show'

  # ROSTER CRUD
  post '/teams/:id/rosters', to: 'rosters#create'
  get '/teams/:id/rosters', to: 'rosters#show'
  put '/teams/:id/rosters', to: 'rosters#update'
  delete '/teams/:id/rosters', to: 'rosters#destroy'

  # BOTS
  get '/teams/:id/bots', to: 'bots#index'
end
