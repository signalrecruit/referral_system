class Admin::RequirementsController < Admin::ApplicationController
  before_action :set_admin_authorization_parameters, only: [:allow_changes_to_requirement]
  before_action :set_jd, except: [:allow_changes_to_requirement]
  before_action :set_requirement, only: [:show]	
  layout "admin"
  	
  
  def index
    @requirements = @jd.requirements.all	
    fresh_when @requiremnts.maximum(:updated_at)
  end

  def show
  end

  def allow_changes_to_requirement
    @requirement = @requirement = Requirement.find(params[:id])
    @requirement_copy = if requirement_copy = Requirement.find_by(copy: true, copy_id: @requirement.id)
                            requirement_copy
                          end 
    
    if @requirement.content != @requirement_copy.content

      requirement_copy_attributes = @requirement_copy.attributes 
      requirement_copy_attributes.delete("id")
      requirement_copy_attributes["copy"] = false 
      requirement_copy_attributes["copy_id"] = nil 
      @requirement.update(requirement_copy_attributes)
      @requirement_copy.delete
      AuthorizeRequirementUpdateNotificationService.new({ actor: current_user, action: "authorize", resource: @requirement, resource_type: @requirement.class.name }).notify_user 
      flash[:success] = "changes have been incorporated."
    end     
    redirect_to :back 
  end



  private

  def set_jd
    @jd = JobDescription.find(params[:job_description_id])	
  end

  def set_requirement
  	set_jd
  	@requirement = @jd.requirements.find(params[:id])
    fresh_when @requirement
  end

  def requirement_params
  	params.require(:requirement).permit(:content)
  end

  def set_admin_authorization_parameters 
    @requirement = Requirement.find(params[:id])
    Authorization::AdminAuthorizationPolicy.new(current_user, @requirement, @requirement.class.name, self).implement_authorization_policy
  end
end
