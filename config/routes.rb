Rails.application.routes.draw do

  devise_for :users
  root to: 'dashboard#index'
  get 'dashboard/activity_feed', to: 'dashboard#activity_feed', as: :activity_feed
  
  patch 'companies/:id/update_button', to: 'companies#update_button', as: :update_button

  resources :user, only: [] do 
    resources :companies 
  end
end
