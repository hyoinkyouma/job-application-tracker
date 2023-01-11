Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "/search", to: "job_search#index"
  post "/search", to: "job_search#search"
  # Defines the root path route ("/")
  root "main_page#index"
  # root "articles#index"
end
