Rails.application.routes.draw do
  devise_for :users, controllers: { invitations: 'users/invitations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  match "/404", to: "errors#not_found", via: :all

  # Defines the root path route ("/")
  # root "posts#index"


  resources :tenants
  resources :onboarding
  resources :users
  resources :businesses do
    get :display_scraped_data, on: :collection
    resources :services do
      get :search, on: :collection
    end
  
    resources :bookings do
      patch :move, on: :member 
    end  
  end
  
  get 'subscription', to: "payments#new", as: :subscription
  post 'payments/checkout', to: "payments#checkout"
  get 'payments/success', to: "payments#success" 
  get 'payments/cancel', to: "payments#cancel"
  get 'customers/search', to: "customers#search", as: :search_customer
  get 'settings', to: "users#index", as: :user_settings
  post "/webhooks/stripe", to: "webhooks/stripe#create"
  root "dashboard#home"
end
