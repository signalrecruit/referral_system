Rails.application.routes.draw do

  namespace :admin do 
    get 'dashboard/dashboard', to: 'dashboard#dashboard', as: :dashboard
    get 'dashboard/activity_feed', to: 'dashboard#activity_feed', as: :activity_feed
    patch 'companies/:id/update_button', to: 'companies#update_button', as: :update_button_for_company
    patch 'job_descriptions/:id/update_button', to: 'job_descriptions#update_button', as: :update_button_for_jd
    patch 'admin_users/:id/update_button', to: 'admin_users#update_button', as: :update_button_for_admin

    # resources :users, only: [] do 
    #   resources :companies
    # end
    resources :admin_users
    
    resources :companies do 
      resources :job_descriptions
    end
  end

  devise_for :users, controllers: { registrations: :registrations  }

  root to: 'dashboard#index'
  get 'dashboard/activity_feed', to: 'dashboard#activity_feed', as: :activity_feed
  
  patch 'companies/:id/update_button', to: 'companies#update_button', as: :update_button_for_company
  patch 'job_descriptions/:id/update_button', to: 'job_descriptions#update_button', as: :update_button_for_jd

  resources :user, only: [] do 
    resources :companies 
  end

  resources :companies do 
    resources :job_descriptions
  end
end
