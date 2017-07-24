module Authorization
  class AdminAuthorizationPolicy
  	def initialize(user, resource, controller)
  	  @user = user 
  	  @resource = resource
  	  @controller = controller
  	end

  	def implement_authorization_policy
      if @user.roles.where(role: "owner", company_id: @resource.id, user_id: @user.id).any?
      else
      	@controller.flash[:alert] = "you are not allowed to alter this information"
      	@controller.redirect_to :back
      end
  	end
  end

  class UserAuthorizationPolicy 
  end
end