class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user

  def edit_user_profile
  	@current_user.update(update_button: true)
  	redirect_to :back
  end

  def complete_profile
    @current_user.update(done: false)
    redirect_to :back
  end

  def update_profile
    @current_user.update(update_button: true)
    @current_user.bank_accounts.each do |bank_account|
      bank_account.update(update_button: true)
    end
  	redirect_to :back
  end


  private 

  def set_current_user
  	@current_user = current_user 
  end	
end
