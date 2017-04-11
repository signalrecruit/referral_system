Rails.application.routes.draw do

  devise_for :users
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
