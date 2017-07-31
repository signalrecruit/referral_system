class Admin::RequiredExperiencesController < ApplicationController
  before_action :set_admin_authorization_parameters, only: [:allow_changes_to_req_exp]
  layout "admin"

  
  def allow_changes_to_req_exp
  	@req_exp = @req_exp = RequiredExperience.find(params[:id])
  	@req_exp_copy = if req_exp_copy = RequiredExperience.find_by(copy: true, copy_id: @req_exp.id)
                            req_exp_copy
                          end 
    
    if (@req_exp.experience != @req_exp_copy.experience) || (@req_exp.years != @req_exp_copy.years)

      req_exp_copy_attributes = @req_exp_copy.attributes 
      req_exp_copy_attributes.delete("id")
      req_exp_copy_attributes["copy"] = false 
      req_exp_copy_attributes["copy_id"] = nil 
      @req_exp.update(req_exp_copy_attributes)
      @req_exp_copy.delete
      AuthorizeReqExpUpdateNotificationService.new({ actor: current_user, action: "authorize", resource: @req_exp, resource_type: @req_exp.class.name }).notify_user 
      flash[:success] = "changes have been incorporated."
    end     
    redirect_to :back 
  end


  private 

  def set_admin_authorization_parameters 
    @req_exp = RequiredExperience.find(params[:id])
  	Authorization::AdminAuthorizationPolicy.new(current_user, @req_exp, @req_exp.class.name, self).implement_authorization_policy
  end
end
