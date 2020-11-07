Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope :api do
    scope :v1 do
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
      # RANDOM ROSTER
      get '/teams/:id/rosters/random', to: 'rosters#random'
    
      # BOTS
      get '/teams/:id/bots', to: 'bots#index'
    end
  end
end
