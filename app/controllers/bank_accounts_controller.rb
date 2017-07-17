class BankAccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: [:show, :edit, :update, :destroy, :edit_bank_details]


  def index
  	@bank_accounts = BankAccount.all.order(created_at: :asc)
  end

  def show
  end

  def new
  	@bank_account = current_user.bank_accounts.build
  end

  def create
  	@bank_account = current_user.bank_accounts.build(account_params)

  	if @bank_account.save 
      on_success "your bank details have been saved successfully!", edit_user_registration_url
  	else 
      on_failure "oops! something went wrong", :new
  	end
  end

  def edit
  end

  def update
  	if @bank_account.update(account_params)
  	   @bank_account.update(update_button: false)
       on_success "your bank details have been updated successfully", :back
  	else 
      on_failure "oops! something went wrong. your bank details failed to update.", :edit
  	end
  end

  def destroy
  	@bank_account.destroy 
    on_success  "you successfully deleted your bank account details", :new
  end

  def edit_bank_details
    @bank_account.update(update_button: true) 
    redirect_to :back
  end


  private

  def account_params
  	params.require(:bank_account).permit(:account_holder, :account_number, :bank_name, :sort_code, :account_holder_address, :user_id)
  end

  def set_account 
  	@bank_account = BankAccount.find(params[:id])
  end
end
