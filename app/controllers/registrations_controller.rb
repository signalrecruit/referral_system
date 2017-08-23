class RegistrationsController < Devise::RegistrationsController
  layout :choose_layout

  def edit
    if current_user && (current_user.bank_accounts.empty? && current_user.payment_option == "bank")
      flash.now[:warning] = "Hello, #{current_user.fullname}. You chose bank as your payment option. Here is a reminder to fill out your bank account details." 
    elsif current_user && (current_user.bank_accounts.empty? && current_user.payment_option == "none")
      flash.now[:info] = "Hello, #{current_user.fullname}. Please choose a payment option." 
    end
  end


  private

  def choose_layout
    resource.admin? ? "admin" : "application"
  end
  
  protected

  def after_sign_in_path_for(resource)
    if resource.bank_accounts.any?
      root_url
    else  
      new_user_bank_account_url(resource)
    end
  end

  def after_update_path_for(resource)
    if resource.admin?
      admin_dashboard_url
    else
      resource.update(update_button: false)
      edit_user_registration_url
    end
  end
end