Rails.application.routes.draw do
  root "searches#index"

  resources :articles, only: :show
  resource :search, only: [ :show ], controller: :searches
  resources :search_events, only: [ :create ]

  namespace :analytics do
    resources :terms, only: [ :index ]
  end
end
