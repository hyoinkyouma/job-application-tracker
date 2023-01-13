Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :events
  
  get "/search", to: "job_search#index"
  post "/search", to: "job_search#search"
  post "/save_job", to: "job_search#newJob", as: "save_job"
  get "/job_search/:id/edit_job", to: "job_search#edit", as: "edit_job"
  resources :job_search
  # Defines the root path route ("/")
  root "main_page#index"
  # root "articles#index"
end
