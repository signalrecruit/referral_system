module Authorization
  class AdminAuthorizationPolicy
  	def initialize(user, resource, resource_type, controller)
  	  @user = user 
  	  @resource = resource
  	  @resource_type = resource_type
  	  @controller = controller
  	end

  	def implement_authorization_policy
      if @user.roles.where(role: "owner", resource_id: @resource.id, resource_type: @resource_type, user_id: @user.id).any?
      else
      	@controller.flash[:alert] = "you are not allowed to alter this information"
      	@controller.redirect_to :back
      end
  	end
  end

  class UserAuthorizationPolicy 
  end
end
# also consider switching roles by super admin