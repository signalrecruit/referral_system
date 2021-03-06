Rails.application.routes.draw do

  get 'bug_report/show'

  namespace :admin do
  get 'bug_reports/index'
  end

  namespace :admin do 
    get 'dashboard/dashboard', to: 'dashboard#dashboard', as: :dashboard
    # get 'dashboard/activity_feed', to: 'dashboard#activity_feed', as: :activity_feed
    patch 'companies/:id/update_button', to: 'companies#update_button', as: :update_button_for_company
    patch 'companies/:id/contact_company', to: 'companies#contact_company', as: :contact_company
    patch 'companies/:id/allow_changes_to_company', to: 'companies#allow_changes_to_company', as: :allow_changes_to_company
    patch 'companies/:id/deal_with_company', to: 'companies#deal_with_company', as: :deal_with_company

    patch 'job_descriptions/:id/update_button', to: 'job_descriptions#update_button', as: :update_button_for_jd
    patch 'job_descriptions/:id/allow_changes_to_jd', to: 'job_descriptions#allow_changes_to_jd', as: :allow_changes_to_jd
    patch 'applicants/:id/allow_changes_to_applicant', to: 'applicants#allow_changes_to_applicant', as: :allow_changes_to_applicant

    patch 'qualifications/:id/allow_changes_to_qualification', to: 'qualifications#allow_changes_to_qualification', as: :allow_changes_to_qualification
    patch 'required_experiences/:id/allow_changes_to_req_exp', to: 'required_experiences#allow_changes_to_req_exp', as: :allow_changes_to_req_exp
    patch 'requirements/:id/allow_changes_to_requirement', to: 'requirements#allow_changes_to_requirement', as: :allow_changes_to_requirement

    patch 'admin_users/:id/update_button', to: 'admin_users#update_button', as: :update_button_for_admin
    get 'activity_feed/index', to: 'activity_feed#index', as: :activity_feed
    get 'activity_feed/show', to: 'activity_feed#show', as: :show_activity
    patch 'messages/:id/send_message', to: 'messages#send_message', as: :send_message
    patch  'messages/:id/archive_message', to: 'messages#archive_message', as: :archive_message
    patch  'messages/:id/unarchive_message', to: 'messages#unarchive_message', as: :unarchive_message
    patch 'applicants/:id/update_salary', to: 'applicants#update_salary', as: :update_salary
    patch 'applicants/:id/update_button', to: 'applicants#update_button', as: :update_button_for_applicants
    get 'applicants/all_applicants', to: 'applicants#all_applicants', as: :manage_all_applicants
    patch 'users/:id/approve', to: 'users#approve', as: :approve_user
    patch 'users/:id/disapprove', to: 'users#disapprove', as: :disapprove_user
    patch 'applicants/:id/shortlist', to: 'applicants#shortlist', as: :shortlist_applicant
    patch 'applicants/:id/interviewing', to: 'applicants#interviewing', as: :interviewing_applicant
    patch 'applicants/:id/testing', to: 'applicants#testing', as: :testing_applicant
    patch 'applicants/:id/salary_negotiation', to: 'applicants#salary_negotiation', as: :negotiating_applicant_salary
    patch 'applicants/:id/hire', to: 'applicants#hire', as: :hire_applicant
    patch 'applicants/:id/unhire', to: 'applicants#unhire', as: :unhire_applicant
    get 'users/reset_cumulative_earnings', to: 'users#reset_cumulative_earnings', as: :reset_cumulative_earnings
    get 'notifications/:id/mark_as_read', to: 'notifications#mark_as_read', as: :mark_notification_as_read
    get 'notifications/mark_all_as_read', to: 'notifications#mark_all_as_read', as: :mark_all_as_read
    get 'notifications/mark_all_as_seen', to: 'notifications#mark_all_as_seen', as: :mark_all_as_seen
    get 'roles/set_role', to: 'roles#set_role', as: :set_role
    get 'roles/unset_role', to: 'roles#unset_role', as: :unset_role

    
    # scope module: "admin" do 
    #   resources :messages do 
    #     member do 
    #       patch 'read_by_admin_at'
    #     end
    #   end
    # end

    
    # resources :users, only: [] do 
    #   resources :companies
    # end
    resources :admin_users
    resources :users, only: [:index, :show]
    
    resources :companies do 
      resources :job_descriptions
    end

    resources :job_descriptions, only: [:index] do 
      resources :requirements, only: [:index, :show]
      resources :applicants
    end

    resources :messages

    resources :applicants, only: [] do 
      resources :comments
    end

    resources :activity_logs, only: [:index, :show]
    resources :bug_reports, only: [:index, :show]
  end

  devise_for :users, controllers: { registrations: :registrations, confirmations: :confirmations }

  root to: 'dashboard#index'
  # get 'dashboard/activity_feed', to: 'dashboard#activity_feed', as: :activity_feed
  
  patch 'companies/:id/update_button', to: 'companies#update_button', as: :update_button_for_company
  patch 'job_descriptions/:id/update_button', to: 'job_descriptions#update_button', as: :update_button_for_jd
  patch 'applicants/:id/update_button', to: 'applicants#update_button', as: :update_button_for_applicants
  patch 'requirements/:id/update_button', to: 'requirements#update_button', as: :update_button_for_rq
  patch 'qualifications/:id/update_button', to: 'qualifications#update_button', as: :update_button_for_qualification
  patch 'required_experiences/:id/update_button', to: 'required_experiences#update_button', as: :update_button_for_exp
  patch 'job_descriptions/:id/complete_job_description', to: 'job_descriptions#complete_job_description', as: :complete_jd
  patch 'job_descriptions/:id/update_job_description', to: 'job_descriptions#update_job_description', as: :update_jd
  get 'activity_feed/index', to: 'activity_feed#index', as: :activity_feed
  get 'activity_feed/show', to: 'activity_feed#show', as: :show_activity
  patch 'messages/:id/send_message', to: 'messages#send_message', as: :send_message
  patch  'messages/:id/archive_message', to: 'messages#archive_message', as: :archive_message
  patch  'messages/:id/unarchive_message', to: 'messages#unarchive_message', as: :unarchive_message
  get 'user_stats/statistics', to: 'user_stats#statistics', as: :user_stats
  patch 'users/edit_user_profile', to: 'users#edit_user_profile', as: :edit_user_profile
  patch 'bank_accounts/:id/edit_bank_details', to: 'bank_accounts#edit_bank_details', as: :edit_bank_details
  patch 'users/:id/complete_profile', to: 'users#complete_profile', as: :complete_profile
  patch 'users/:id/update_profile', to: 'users#update_profile', as: :update_profile
  get 'notifications/:id/mark_as_read', to: 'notifications#mark_as_read', as: :mark_notification_as_read
  get 'notifications/mark_all_as_read', to: 'notifications#mark_all_as_read', as: :mark_all_as_read
  get 'notifications/mark_all_as_seen', to: 'notifications#mark_all_as_seen', as: :mark_all_as_seen
  
  patch 'messages/:id/read_by_user', to: 'messages#read_by_user', as: :read_by_user


  resources :user, only: [] do 
    resources :companies, :bank_accounts 
  end

  resources :companies do 
    resources :job_descriptions
  end

  resources :job_descriptions, only: [] do 
    resources :requirements, :applicants, :qualifications, :required_experiences
  end

  resources :messages
  resources :applicants, only: [] do 
    resources :requirement_scores
  end

  resources :attachments, only: [:new, :show, :destroy] 

  match "*path", to: "application#routing_error", via: :all if Rails.env.production?
end
