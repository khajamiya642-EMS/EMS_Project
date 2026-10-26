Rails.application.routes.draw do
  # Devise routes for user authentication
  # devise_for :users

  # Full CRUD routes for employees
  # resources :employees

  # Root path
  # root to: "employees#index"

  # Health check route
  # get "up" => "rails/health#show", as: :rails_health_check

  # Example PWA routes (commented out until needed)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  # Rails.application.routes.draw do
  devise_for :users
  resources :employees do
    member do
      get :subordinates
    end
  end
  root "employees#index"
end
