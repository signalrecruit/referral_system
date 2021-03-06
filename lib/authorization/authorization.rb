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
      	@controller.flash[:alert] = "NOTE: you have no ownership of this resource. you must set ownership to you in order to have write access to this resource."
      	@controller.redirect_to :back
      end
  	end
  end

  class UserAuthorizationPolicy 
  end
end
# also consider switching roles by super admin