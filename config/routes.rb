Rails.application.routes.draw do
 
  devise_for :users
  root to: 'dashboard#index'
  get 'dashboard/activity_feed', to: 'dashboard#activity_feed', as: :activity_feed

end
