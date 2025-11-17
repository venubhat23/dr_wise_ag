Rails.application.routes.draw do
  get "dashboard/index"
  devise_for :users

  # Root route
  root "dashboard#index"

  # Dashboard
  get 'dashboard', to: 'dashboard#index'

  # Admin routes
  namespace :admin do
    # Users (Admins/Agents) management
    resources :users

    # Customer management
    resources :customers do
      resources :family_members
    end

    # Insurance management
    resources :policies do
      member do
        get :download_pdf
      end
    end

    # Life Insurance
    resources :life_insurances, path: 'insurance/life'

    # Health Insurance
    resources :health_insurances, path: 'insurance/health'

    # Motor Insurance
    resources :motor_insurances, path: 'insurance/motor'

    # Other Insurance
    resources :other_insurances, path: 'insurance/other'

    # Agency/Broker management
    resources :agency_brokers

    # Insurance companies
    resources :insurance_companies

    # Leads management
    resources :leads do
      member do
        patch :convert_to_customer
        patch :create_policy
        patch :transfer_referral
      end
    end

    # Banner management
    resources :banners

    # Reports
    get 'reports/commission', to: 'reports#commission'
    get 'reports/expired_insurance', to: 'reports#expired_insurance'
    get 'reports/payment_due', to: 'reports#payment_due'
    get 'reports/upcoming_renewal', to: 'reports#upcoming_renewal'
    get 'reports/upcoming_payment', to: 'reports#upcoming_payment'
    get 'reports/leads', to: 'reports#leads'
    get 'reports/sessions', to: 'reports#sessions'

    # Import/Export
    post 'import/customers', to: 'imports#customers'
    post 'import/agencies', to: 'imports#agencies'
  end

  # Mobile API routes
  namespace :api do
    namespace :v1 do
      # Authentication APIs
      post 'auth/login', to: 'authentication#login'
      post 'auth/register', to: 'authentication#register'
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check
end
