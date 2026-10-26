Rails.application.routes.draw do
  devise_for :users
  resources :departments
  resources :employees do
    get :subordinates, on: :member
  end
  get "teams", to: "employees#teams", as: :teams

  root "employees#index"
end
