Rails.application.routes.draw do
  get "dashboard/index"
  devise_for :users

  # Custom sign_out route to handle GET requests
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  # Root route
  root "dashboard#index"

  # Dashboard
  get 'dashboard', to: 'dashboard#index'

  # Admin routes
  namespace :admin do
    resources :payouts do
      member do
        patch :mark_as_paid
        patch :mark_as_processing
        patch :cancel_payout
        get :audit_trail
      end
      collection do
        get :policies_by_type
        get :commission_receipts
        post :auto_distribute
        get :reports
        get :summary
      end
    end
    # Users (Admins/Agents) management
    resources :users

    # Roles and Permissions management
    resources :roles do
      member do
        patch :toggle_status
        post :assign_users
      end
      collection do
        get :permissions_preview
      end
    end

    resources :permissions do
      member do
        # Individual permission management
      end
      collection do
        post :generate_defaults
        get :bulk_assign
        post :bulk_update
        get 'module/:module_name', action: :module_permissions, as: :module
      end
    end

    # Sub Agent management
    resources :sub_agents do
      member do
        patch :toggle_status
      end
    end

    # Distributor management
    resources :distributors do
      member do
        patch :toggle_status
      end
    end

    # Investor management
    resources :investors do
      member do
        patch :toggle_status
      end
    end

    # Customer management
    resources :customers do
      member do
        patch :toggle_status
        get :policy_chart
      end
      collection do
        get :export
      end
      resources :family_members
    end

    # Insurance management
    resources :policies do
      member do
        get :download_pdf
      end
    end

    # Life Insurance
    resources :life_insurances, path: 'insurance/life' do
      collection do
        get :policy_holder_options
      end
      member do
        get :commission_details
        patch :remove_rider
      end
    end

    # Health Insurance
    resources :health_insurances, path: 'insurance/health' do
      collection do
        get :policy_holder_options
      end
    end

    # Motor Insurance
    resources :motor_insurances, path: 'insurance/motor' do
      collection do
        get :policy_holder_options
      end
    end

    # Other Insurance
    resources :other_insurances, path: 'insurance/other'

    # Agency/Broker management
    resources :agency_brokers

    # Broker management
    resources :brokers do
      member do
        patch :toggle_status
      end
    end

    # Agency Code management
    resources :agency_codes do
      collection do
        get :search
      end
    end

    # Insurance companies
    resources :insurance_companies

    # Helpdesk management
    resources :helpdesk, path: 'helpdesk' do
      member do
        patch :update_status
        patch :assign_to
        patch :add_response
      end
      collection do
        get :analytics
        get :tickets
        get :knowledge_base
      end
    end

    # Client Requests management
    resources :client_requests do
      member do
        patch :update_status
        patch :assign_to
        patch :add_response
      end
      collection do
        get :pending
        get :in_progress
        get :resolved
        get :search
      end
    end

    # Leads management
    resources :leads do
      member do
        patch :convert_to_customer
        patch :create_policy
        patch :transfer_referral
        patch :advance_stage
        patch :go_back_stage
        patch :update_stage
      end
      collection do
        get :export
        get :statistics
        patch :bulk_update_stage
      end
    end

    # Banner management
    resources :banners do
      member do
        patch :toggle_status
      end
    end

    # Reports
    get 'reports/commission', to: 'reports#commission'
    get 'reports/expired_insurance', to: 'reports#expired_insurance'
    get 'reports/payment_due', to: 'reports#payment_due'
    get 'reports/upcoming_renewal', to: 'reports#upcoming_renewal'
    get 'reports/upcoming_payment', to: 'reports#upcoming_payment'
    get 'reports/leads', to: 'reports#leads'
    get 'reports/sessions', to: 'reports#sessions'

    # Import Section
    resources :imports, only: [:index] do
      collection do
        get :customers_form
        get :sub_agents_form
        get :health_insurances_form
        get :life_insurances_form
        get :motor_insurances_form
        get :download_template
      end
    end

    # Import/Export
    post 'import/customers', to: 'imports#customers'
    post 'import/sub_agents', to: 'imports#sub_agents'
    post 'import/health_insurances', to: 'imports#health_insurances'
    post 'import/life_insurances', to: 'imports#life_insurances'
    post 'import/motor_insurances', to: 'imports#motor_insurances'
    post 'import/agencies', to: 'imports#agencies'

    # Settings namespace
    namespace :settings do
      resources :user_roles do
        member do
          patch :toggle_status
        end
      end

      # System settings (placeholder for future expansion)
      get :system, to: 'system#index'
      patch :system, to: 'system#update'
      put :system, to: 'system#update'
    end
  end

  # Mobile API routes
  namespace :api do
    namespace :v1 do
      # Authentication APIs (Admin/Web)
      post 'auth/login', to: 'authentication#login'
      post 'auth/register', to: 'authentication#register'
      post 'auth/forgot_password', to: 'authentication#forgot_password'
      post 'auth/reset_password', to: 'authentication#reset_password'

      # Mobile API Routes
      namespace :mobile do
        # Mobile Authentication APIs
        post 'auth/login', to: 'authentication#login'
        post 'auth/register', to: 'authentication#register'
        post 'auth/forgot_password', to: 'authentication#forgot_password'

        # Customer Module APIs
        get 'customer/portfolio', to: 'customer#portfolio'
        get 'customer/upcoming_installments', to: 'customer#upcoming_installments'
        get 'customer/upcoming_renewals', to: 'customer#upcoming_renewals'
        post 'customer/add_policy', to: 'customer#add_policy'

        # Settings Module APIs
        get 'settings/profile', to: 'settings#profile'
        put 'settings/profile', to: 'settings#update_profile'
        post 'settings/change_password', to: 'settings#change_password'
        get 'settings/terms', to: 'settings#terms_and_conditions'
        get 'settings/contact', to: 'settings#contact_us'
        post 'settings/helpdesk', to: 'settings#helpdesk'
        get 'settings/notifications', to: 'settings#notification_settings'
        put 'settings/notifications', to: 'settings#update_notification_settings'

        # Agent Dashboard APIs
        get 'agent/dashboard', to: 'agent#dashboard'
        get 'agent/customers', to: 'agent#customers'
        post 'agent/customers', to: 'agent#add_customer'
        get 'agent/policies', to: 'agent#policies'
        post 'agent/policies/health', to: 'agent#add_health_policy'
        post 'agent/policies/life', to: 'agent#add_life_policy'
        post 'agent/policies/motor', to: 'agent#add_motor_policy'
        post 'agent/policies/other', to: 'agent#add_other_policy'
        get 'agent/form_data', to: 'agent#form_data'
        get 'agent/insurance_companies', to: 'agent#insurance_companies'

        # Leads APIs
        get 'agent/leads', to: 'agent#leads'
        post 'agent/leads', to: 'agent#add_lead'

        # Commission Distribution APIs
        get 'agent/commission_distribution', to: 'agent#commission_distribution'
        get 'agent/commission_summary', to: 'agent#commission_summary'
      end

      # Sub Agent APIs
      resources :sub_agents do
        member do
          patch :toggle_status
        end
      end

      # Customer APIs
      resources :customers do
        member do
          patch :toggle_status
        end
      end

      # Health Insurance APIs
      resources :health_insurances do
        collection do
          get :statistics
          get :form_data
          get :policy_holder_options
        end
      end

      # Life Insurance APIs
      resources :life_insurances do
        collection do
          get :statistics
          get :form_data
          get :policy_holder_options
        end
      end
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check
end
