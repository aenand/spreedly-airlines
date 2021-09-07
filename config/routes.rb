Rails.application.routes.draw do
  root'flights#index', as: 'flights'
  get 'flights/index'
  resources :bookings, only: [:new, :create, :index, :show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
