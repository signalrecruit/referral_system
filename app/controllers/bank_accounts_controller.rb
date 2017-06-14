class BankAccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: [:show, :edit, :update, :destroy]


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
  	  flash[:success] = "your bank details have been saved successfully!"
  	  redirect_to root_url 
  	else 
  	  flash[:alert] = "oops! something went wrong"
  	  render :new	
  	end
  end

  def edit
  end

  def update
  	if @bank_account.update(account_params)
  	  flash[:success] = "your bank details have been updated successfully"
  	  redirect_to @bank_account
  	else 
  	  flash[:alert] = "oops! something went wrong. your bank details failed to update."
  	  render :edit	
  	end
  end

  def destroy
  	@bank_account.destroy 
  	flash[:success] = "you successfully deleted your bank account details"
  	redirect_to :new
  end


  private

  def account_params
  	params.require(:bank_account).permit(:account_holder, :account_number, :bank_name, :sort_code, :account_holder_address, :user_id)
  end

  def set_account 
  	@bank_account = BankAccount.find(params[:id])
  end
end
