class Admin::RolesController < Admin::ApplicationController
  before_action :check_for_existing_ownership, only: [:set_role]
  layout "admin"

  def set_role 
  	@company_id = params[:resource_id].to_i
    @resource = Company.find(@company_id)
  	@resource_type = params[:resource_type]

    if role_with_no_owner?(@resource.id, @resource_type)
      role = Role.find_by role: "no owner", resource_id: @resource.id, resource_type: "Company"
      role.update(role: "owner", user_id: current_user.id) 
    else
      Role.create role: "owner", user_id: current_user.id, resource_id: @resource.id, resource_type: @resource_type  unless Role.where(role: "owner", user_id: current_user.id, resource_id: @resource.id, resource_type: "Company").any?
    end
    set_ownership_for_associated_resources
    redirect_to :back
  end 	

  def unset_role
    @company_id = params[:resource_id].to_i
    @resource = Company.find(@company_id)
  	@resource_type = params[:resource_type]
  	role = Role.find_by role: "owner", user_id: current_user.id, resource_id: @resource.id, resource_type: @resource_type  
  	role.update(role: "no owner", user_id: nil) if role

  	unset_ownership_for_associated_resources
    redirect_to :back
  end


  private 

  def set_ownership_for_associated_resources
    if @resource.job_descriptions.any?	
      @resource.job_descriptions.each do |jd|
        if role_with_no_owner?(jd.id, jd.class.name)
          role = Role.find_by role: "no owner", resource_id: jd.id, resource_type: "JobDescription"
          role.update(role: "owner", user_id: current_user.id) if role
        else
          Role.create role: "owner", user_id: current_user.id, resource_id: jd.id, resource_type: "JobDescription" unless Role.where(role: "owner", user_id: current_user.id, resource_id: jd.id, resource_type: "JobDescription").any?
        end
      end
    end

    if @resource.applicants.any?
      @resource.applicants.each do |applicant|
        if role_with_no_owner?(applicant.id, applicant.class.name)
          role = Role.find_by role: "no owner", resource_id: applicant.id, resource_type: "Applicant"
          role.update(role: "owner", user_id: current_user.id) if role
        else
          Role.create role: "owner", user_id: current_user.id, resource_id: applicant.id, resource_type: "Applicant" unless Role.where(role: "owner", user_id: current_user.id, resource_id: applicant.id, resource_type: "Applicant").any?
        end
      end	
    end	
  end

  def unset_ownership_for_associated_resources
  	if @resource_type == "company"
      if @resource.job_descriptions.any?	
        @resource.job_descriptions.each do |jd|
          role = Role.find_by role: "owner", user_id: current_user.id, resource_id: @resource.id, resource_type: "JobDescription"
          role.update(role: "no owner", user_id: nil) if role
          if jd.applicants.any?
            jd.applicants.each do |applicant|
              role = Role.find_by role: "owner", user_id: current_user.id, resource_id: @resource.id, resource_type: "Applicant"
              role.update(role: "no owner", user_id: nil) if role
            end	
          end	
        end	
      end
    end
  end

  def role_with_no_owner?(resource_id, resource_type)
    Role.find_by role: "no owner", resource_id: resource_id, resource_type: resource_type
  end

  def check_for_existing_ownership
    @company_id = params[:resource_id].to_i
    @resource = Company.find(@company_id)
    if Role.where(role: "owner", resource_id: @resource.id, resource_type: @company.class.name).any?
      flash[:alert] = "this company is already owned"
      redirect_to :back
    end
  end
end
