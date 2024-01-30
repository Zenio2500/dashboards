Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root "static_pages#index"
  get "about" => "static_pages#about"
  get "contact" => "static_pages#contact"
  get "confirm/edit" => "accounts#confirm_edit_get"
  post "confirm/edit" => "accounts#confirm_edit_post"
  get "confirm/destroy" => "accounts#confirm_destroy_get"
  post "confirm/destroy" => "accounts#confirm_destroy_post"
  get "destroyer" => "accounts#destroyer"
  get "entry" => "sessions#new"
  post "entry" => "sessions#create"
  get "exit" => "sessions#destroy"
  resources :accounts, only: [:show, :new, :edit, :create, :destroy, :update]
  resources :accounts do
    resources :dashboards, only: [:index, :show, :new, :create, :edit, :update, :destroy]
    resources :dashboards do
      resources :to_do_tasks, only: [:new, :create, :edit, :update, :destroy]
    end
    resources :dashboards do
      resources :in_progress_tasks, only: [:new, :create, :edit, :update, :destroy]
    end
    resources :dashboards do
      resources :finished_tasks, only: [:new, :create, :edit, :update, :destroy]
    end
  end
  #resources :dashboards, only: [:new, :create]
end
