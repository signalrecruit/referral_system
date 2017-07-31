class Admin::QualificationsController < ApplicationController
  before_action :set_admin_authorization_parameters, only: [:allow_changes_to_qualification]
  layout "admin"

  
  def allow_changes_to_qualification
  	@qualification = @qualification = Qualification.find(params[:id])
  	@qualification_copy = if qualification_copy = Qualification.find_by(copy: true, copy_id: @qualification.id)
                            qualification_copy
                          end 
    
    if (@qualification.certificate != @qualification_copy.certificate) || (@qualification.field_of_study != @qualification_copy.field_of_study)

      qualification_copy_attributes = @qualification_copy.attributes 
      qualification_copy_attributes.delete("id")
      qualification_copy_attributes["copy"] = false 
      qualification_copy_attributes["copy_id"] = nil 
      @qualification.update(qualification_copy_attributes)
      @qualification_copy.delete
      AuthorizeQualificationUpdateNotificationService.new({ actor: current_user, action: "authorize", resource: @qualification, resource_type: @qualification.class.name }).notify_user 
      flash[:success] = "changes have been incorporated."
    end     
    redirect_to :back 
  end


  private 

  def set_admin_authorization_parameters 
    @qualification = Qualification.find(params[:id])
  	Authorization::AdminAuthorizationPolicy.new(current_user, @qualification, @qualification.class.name, self).implement_authorization_policy
  end
end
