Rails.application.routes.draw do
  get "dashboard/index"
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  # Custom sign_out route to handle GET requests
  devise_scope :user do
    get '/users/sign_out' => 'users/sessions#destroy'
  end

  # Root route
  root to: redirect('/dashboard')

  # Favicon route
  get '/favicon.ico', to: redirect('/icon.png')

  # Public pages
  get 'adhika/privacy-policy', to: 'public_pages#adhika_privacy_policy'
  get 'adhika/account-deletion-policy', to: 'public_pages#adhika_account_deletion_policy'

  # Dashboard
  get 'dashboard', to: 'dashboard#index'
  get 'dashboard/beautiful', to: 'dashboard#beautiful'
  get 'dashboard/ultra', to: 'dashboard#ultra'
  get 'dashboard/stats', to: 'dashboard#stats'

  # Ambassador Dashboard
  get 'ambassador/dashboard', to: 'ambassador#dashboard'
  get 'ambassador/commission_details', to: 'ambassador#commission_details'
  get 'ambassador/payout_history', to: 'ambassador#payout_history'

  # Investor Dashboard
  get 'investor/dashboard', to: 'investor#dashboard'
  get 'investor/profit_summary', to: 'investor#profit_summary'
  get 'summary-investor', to: 'investor#profit_summary'

  # API routes
  namespace :api do
    resources :cities, only: [:index]
    namespace :v1 do
      # Public API endpoints (no authentication required)
      get 'public/search_sub_agents', to: 'public#search_sub_agents'
      get 'public/sub_agent_details', to: 'public#sub_agent_details'
      get 'public/search_distributors', to: 'public#search_distributors'
      get 'public/insurance_companies', to: 'public#insurance_companies'
      get 'public/motor_insurance_companies', to: 'public#motor_insurance_companies'
    end
  end

  # Admin routes
  namespace :admin do
    # API routes for dashboard modals
    namespace :api do
      resources :policies, only: [] do
        collection do
          get :expiring
          get :expired
          get :processed
          get 'health/expiring', to: 'policies#health_expiring'
          get 'health/expired_month', to: 'policies#health_expired_month'
          get 'health/opportunities', to: 'policies#health_opportunities'
        end
      end

      # System Status API endpoints
      resources :system_status, only: [] do
        collection do
          get :active_affiliates
          get :lead_conversion
          get :avg_policy_value
          get :commissions_due_detailed
        end
      end
    end

    # Admin profile management
    get 'profile', to: 'profile#show'
    get 'profile/edit', to: 'profile#edit', as: 'edit_profile'
    patch 'profile', to: 'profile#update'

    # Analytics
    get 'analytics', to: 'analytics#index'
    post 'analytics/refresh', to: 'analytics#refresh'

    # Document management
    resources :documents do
      member do
        get :download
      end
    end

    # Nested document routes for different models
    resources :users do
      resources :documents, except: [:edit, :update]
    end


    resources :customers do
      resources :documents, except: [:edit, :update]
    end
    resources :payouts do
      member do
        patch :mark_as_paid
        patch :mark_as_processing
        patch :cancel_payout
        get :audit_trail
        get :flow_timeline
      end
      collection do
        get :policies_by_type
        get :commission_receipts
        post :auto_distribute
        get :reports
        get :summary
        get 'policies/:policy_id/actions', action: :policy_actions, as: :policy_actions
      end
    end

    # Commission Tracking System
    resources :commission_tracking, only: [:index, :show, :update] do
      member do
        patch :transfer_to_affiliate
        patch :transfer_to_ambassador
        patch :transfer_to_investor
        patch :transfer_company_expense
        patch :mark_main_agent_commission_received
        get :policy_breakdown
      end
      collection do
        get :dashboard
        get :modern_dashboard
        get :summary
        get :policy_search
        post :manual_transfer
        get :commission_details_modal
      end
    end

    # Affiliate Payout System
    resources :affiliate_payouts, only: [:index, :show] do
      collection do
        post :mark_as_paid
        get :unpaid_data
      end
    end

    # Distributor Payout System
    resources :distributor_payouts, only: [:index, :show] do
      collection do
        post :mark_as_paid
        get :unpaid_data
      end
    end

    # Payout 2 System - Comprehensive Payout Management
    resources :payout2, only: [:index] do
      collection do
        patch :mark_as_paid
        get :commission_breakdown
      end
    end

    # Invoice System
    resources :invoices do
      member do
        patch :mark_as_paid
        get :download_pdf
        get :show_premium
        get :download_premium_pdf
      end
      collection do
        post :generate_invoice
      end
    end

    # API endpoints for dashboard and system status
    namespace :api do
      get 'system_status/active_affiliates', to: 'system_status#active_affiliates'
      get 'system_status/lead_conversion', to: 'system_status#lead_conversion'
      get 'system_status/avg_policy_value', to: 'system_status#avg_policy_value'
      get 'system_status/commissions_due_detailed', to: 'system_status#commissions_due_detailed'

      # Policy endpoints for modals
      get 'policies/expiring', to: 'policies#expiring'
      get 'policies/expired', to: 'policies#expired'
      get 'policies/processed', to: 'policies#processed'
      get 'policies/health/expiring', to: 'policies#health_expiring'
      get 'policies/health/expired_month', to: 'policies#health_expired_month'
      get 'policies/health/opportunities', to: 'policies#health_opportunities'
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

    # Sub Agent management (legacy)
    resources :sub_agents do
      member do
        patch :toggle_status
        patch :deactivate
        patch :activate
        get :distributor
        get :documents
      end
      resources :sub_agent_documents, except: [:show, :index] do
        member do
          delete :destroy_immediate
        end
      end
    end

    # Distributor management
    resources :distributors do
      member do
        patch :toggle_status
        patch :deactivate
        patch :activate
      end
      resources :distributor_documents, except: [:show, :index] do
        member do
          delete :destroy_immediate
        end
      end
    end

    # Investor management
    resources :investors do
      member do
        patch :toggle_status
      end
      resources :investor_documents, only: [:destroy]
    end

    # Customer management
    resources :customers do
      collection do
        get :export
        get :cities
        get :search_sub_agents
      end
      member do
        patch :toggle_status
        patch :deactivate
        patch :activate
        get :policy_chart
        get :family_members
        get :affiliate_info
        get :nominee_details
        get :trace_commission
        get :product_selection
        get :get_policies
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
        get :customer_family_members
        get :brokers_by_company
        get :agency_codes_by_broker
        get :all_agency_codes
        get :all_brokers
        get :agency_codes_for_broker_type
        get :insurance_companies_for_type
      end
      member do
        get :commission_details
        get :renew
        post :create_renewal
      end
    end

    # Health Insurance
    resources :health_insurances, path: 'insurance/health' do
      collection do
        get :policy_holder_options
        get :brokers_by_company
        get :agency_codes_by_broker
        get :all_agency_codes
        get :all_brokers
        get :agency_codes_for_broker_type
        get :insurance_companies_for_type
        get :company_name_by_agent
        post :insurance_companies_by_agency
      end
      member do
        get :commission_details
        get :renew
        post :create_renewal
      end
    end

    # Motor Insurance
    resources :motor_insurances, path: 'insurance/motor' do
      collection do
        get :policy_holder_options
        get :customer_affiliate_info
        get :agency_codes_for_broker_type
        get :company_name_by_agent
        get :insurance_companies_for_type
        get :insurance_companies_by_agency
      end
      member do
        get :renew
        post :create_renewal
        delete :delete_document
      end
    end

    # Other Insurance
    resources :other_insurances, path: 'insurance/other' do
      collection do
        get :all_agency_codes
        get :all_brokers
        get :insurance_companies_for_type
        get :insurance_companies_by_agency
      end
      member do
        get :renew
        post :create_renewal
      end
    end

    # Other Insurance - Alternative routes for backward compatibility
    scope :other_insurances, controller: :other_insurances do
      get :all_brokers
      get :insurance_companies_for_type
      get :all_agency_codes
      get :insurance_companies_by_agency
    end

    # Agency/Broker management
    resources :agency_brokers

    # Broker management
    resources :brokers do
      member do
        patch :toggle_status
      end
      collection do
        get :search
      end
      resources :broker_codes, except: [:show]
    end

    # Standalone Broker Codes management (if needed outside broker context)
    resources :broker_codes do
      member do
        patch :toggle_status
      end
      collection do
        get :all_agency_codes
        get :companies_by_agency_code
      end
    end

    # Agency Code management
    resources :agency_codes do
      collection do
        get :search
        get :brokers_for_direct
        get :agents_for_broker
        get :all_agents
        get :companies_for_agent
        get :all_brokers
        get :companies_for_broker
        get :all_companies
        get :companies_by_type
        get :all_codes
        get :agents_for_code
        get :company_for_agency_code
      end
      member do
        get :insurance_companies
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
      resources :documents, except: [:edit, :update]
      member do
        get :convert_to_customer
        patch :convert_to_customer
        patch :convert_to_customer_branch_out
        patch :create_policy
        patch :transfer_referral
        patch :advance_stage
        patch :go_back_stage
        patch :update_stage
        patch :convert_stage
        patch :mark_not_interested
        patch :close_lead
      end
      collection do
        get :export
        get :statistics
        patch :bulk_update_stage
        get :check_existing_customer
        get :search_sub_agents
        post :branch_out
      end
    end

    # Banner management
    resources :banners do
      member do
        patch :toggle_status
      end
    end

    # Reports namespace
    namespace :reports do
      resources :commission_reports, only: [:index] do
        collection do
          get :export
          get :generate
          post :create_report
          post :preview
          get :saved_reports
        end
        member do
          get :show_saved_report
          delete :destroy_saved_report
          get :export_csv
          get :export_pdf
        end
      end

      resources :all_policy_reports, only: [:index, :new, :create, :show, :destroy] do
        collection do
          post :preview
          get :export_csv
        end
        member do
          get :export_csv
        end
      end

      resources :lead_reports, only: [:index, :new, :create] do
        collection do
          post :preview
        end
        member do
          get :show_saved_report
          delete :destroy_saved_report
          get :export_csv
        end
      end

      # Session Reports
      resources :sessions, only: [:index] do
        collection do
          get :export
          post :filter
          get :realtime_data
          get :active_users_details
        end
      end

      resources :expired_insurance_reports, only: [:index] do
        collection do
          get :export
          get :generate
          post :create_report
          post :preview
          get :saved_reports
        end
        member do
          get :show_saved_report
          delete :destroy_saved_report
          get :export_csv
        end
      end
      resources :payment_due_reports, only: [:index] do
        collection do
          get :export
        end
      end
      resources :upcoming_renewal_reports, only: [:index] do
        collection do
          get :export
          get :generate
          post :create_report
          post :preview
          get :saved_reports
        end
        member do
          get :show_saved_report
          delete :destroy_saved_report
          get :export_csv
        end
      end
      resources :upcoming_payment_reports, only: [:index] do
        collection do
          get :export
        end
      end
      resources :leads_reports, only: [:index] do
        collection do
          get :export
        end
      end
      resources :session_reports, only: [:index] do
        collection do
          get :export
        end
      end
    end

    # AI Reports
    resources :ai_reports, only: [] do
      collection do
        get :chat_interface
        post :generate
        post :ask
        get :history
      end
    end

    # Import Section
    resources :imports, only: [:index] do
      collection do
        get :customers_form
        get :sub_agents_form
        get :distributors_form
        get :health_insurances_form
        get :life_insurances_form
        get :motor_insurances_form
        get :download_template
        post :customers_preview
        post :sub_agents_preview
        post :distributors_preview
        post :health_insurances_preview
        post :life_insurances_preview
        post :motor_insurances_preview
      end
    end

    # Import/Export
    post 'import/customers', to: 'imports#customers'
    post 'import/sub_agents', to: 'imports#sub_agents'
    post 'import/distributors', to: 'imports#distributors'
    post 'import/health_insurances', to: 'imports#health_insurances'
    post 'import/life_insurances', to: 'imports#life_insurances'
    post 'import/motor_insurances', to: 'imports#motor_insurances'
    post 'import/agencies', to: 'imports#agencies'

    # Commission management for ambassadors/distributors
    resources :commissions, only: [:index] do
      collection do
        get :dashboard
        get :reports
        get :payouts
        get :affiliates
      end
    end

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

        # Customer Helpdesk APIs
        post 'customer/helpdesk', to: 'customer#create_helpdesk_ticket'
        get 'customer/helpdesk_tickets', to: 'customer#helpdesk_tickets'
        get 'customer/helpdesk_tickets/:id', to: 'customer#helpdesk_ticket_details'

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
        get 'agent/motor_insurance_companies', to: 'agent#motor_insurance_companies'

        # Leads APIs
        get 'agent/leads', to: 'agent#leads'
        post 'agent/leads', to: 'agent#add_lead'

        # Sub Agent APIs
        get 'sub_agent/leads', to: 'sub_agent#leads'
        get 'sub_agent/leads/:id', to: 'sub_agent#lead_details'
        post 'sub_agent/helpdesk', to: 'sub_agent#create_helpdesk_ticket'
        get 'sub_agent/helpdesk_tickets', to: 'sub_agent#helpdesk_tickets'

        # Commission Distribution APIs
        get 'agent/commission_distribution', to: 'agent#commission_distribution'
        get 'agent/commission_summary', to: 'agent#commission_summary'

        # Banner APIs
        resources :banners, only: [:index, :show] do
          collection do
            get :active, to: 'banners#active'
            get :by_location, to: 'banners#by_location'
          end
        end
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

  # Favicon route to serve favicon.ico
  get '/favicon.ico' => 'application#favicon'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check
end
