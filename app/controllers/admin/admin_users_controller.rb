class Admin::AdminUsersController < Admin::ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :update_button]	
  layout "admin"
  
  def index
  	@admins = User.all.where(admin: true, admin_status: 1)
  end

  def show
  end

  def new
  	@admin = User.new
  end
  
  def create
    @admin = User.new(user_params)	

    if @admin.save 
       @admin.update(admin: true, admin_status: 1)	
      flash[:success] = "you have successfully created an admin"
      redirect_to [:admin, :admin, @admin]
    else 
      flash[:alert] = "oops! sthg went wrong"
      render :new	
    end
  end

  def edit
  end
  
  def update
  	if params[:user][:password].blank?
	  params[:user].delete(:password)
	end
  	
  	if @admin.update(user_params)
  	  @admin.update(update_button: false)	
  	  flash[:success] = "you have successfully updated #{@admin.username}'s details"
  	  redirect_to :back
  	else 
  	  flash.now[:alert] = "oops! sthg went wrong"
  	  render :edit	
  	end
  end

  def destroy
  	@admin.destroy
  	redirect_to :back
  end

  def update_button
  	@admin.update(update_button: true)
  	redirect_to :back
  end


  private

  def set_user
  	@admin = User.find(params[:id])
  end

  def user_params
  	params.require(:user).permit!
  end 

end
