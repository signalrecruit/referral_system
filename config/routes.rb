Rails.application.routes.draw do

  get 'activity_feed/index'

  get 'activity_feed/show'

  namespace :admin do 
    get 'dashboard/dashboard', to: 'dashboard#dashboard', as: :dashboard
    # get 'dashboard/activity_feed', to: 'dashboard#activity_feed', as: :activity_feed
    patch 'companies/:id/update_button', to: 'companies#update_button', as: :update_button_for_company
    patch 'job_descriptions/:id/update_button', to: 'job_descriptions#update_button', as: :update_button_for_jd
    patch 'admin_users/:id/update_button', to: 'admin_users#update_button', as: :update_button_for_admin
    patch 'companies/:id/contact_company', to: 'companies#contact_company', as: :contact_company
    patch 'companies/:id/deal_with_company', to: 'companies#deal_with_company', as: :deal_with_company
    get 'activity_feed/index', to: 'activity_feed#index', as: :activity_feed
    get 'activity_feed/show', to: 'activity_feed#show', as: :show_activity

    # resources :users, only: [] do 
    #   resources :companies
    # end
    resources :admin_users
    
    resources :companies do 
      resources :job_descriptions
    end

    resources :job_descriptions, only: [] do 
      resources :requirements, only: [:index, :show]
    end
  end

  devise_for :users, controllers: { registrations: :registrations  }

  root to: 'dashboard#index'
  # get 'dashboard/activity_feed', to: 'dashboard#activity_feed', as: :activity_feed
  
  patch 'companies/:id/update_button', to: 'companies#update_button', as: :update_button_for_company
  patch 'job_descriptions/:id/update_button', to: 'job_descriptions#update_button', as: :update_button_for_jd
  patch 'requirements/:id/update_button', to: 'requirements#update_button', as: :update_button_for_rq
  get 'activity_feed/index', to: 'activity_feed#index', as: :activity_feed
  get 'activity_feed/show', to: 'activity_feed#show', as: :show_activity

  resources :user, only: [] do 
    resources :companies 
  end

  resources :companies do 
    resources :job_descriptions
  end

  resources :job_descriptions, only: [] do 
    resources :requirements
  end
end
