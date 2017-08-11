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
          Role.create role: "owner", user_id: current_user.id, resource_id: jd.id, resource_type: "JobDescription" unless Role
          .where(role: "owner", user_id: current_user.id, resource_id: jd.id, resource_type: "JobDescription").any?
        end
        transfer_ownership_to_jd_associated_resources(jd)
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
  	if @resource_type == "Company"
      if @resource.job_descriptions.any?	
        @resource.job_descriptions.each do |jd|
          role = Role.find_by role: "owner", user_id: current_user.id, resource_id: jd.id, resource_type: "JobDescription"
          role.update(role: "no owner", user_id: nil) if role
          if jd.applicants.any?
            jd.applicants.each do |applicant|
              role = Role.find_by role: "owner", user_id: current_user.id, resource_id: applicant.id, resource_type: "Applicant"
              role.update(role: "no owner", user_id: nil) if role
            end	
          end

          if jd.qualifications.any? 
            jd.qualifications.each do |qualification|
              role = Role.find_by role: "owner", user_id: current_user.id, resource_id: qualification.id, resource_type: "Qualification"
              role.update(role: "no owner", user_id: nil) if role
            end
          end	

          if jd.requirements.any? 
            jd.requirements.each do |requirement|
              role = Role.find_by role: "owner", user_id: current_user.id, resource_id: requirement.id, resource_type: "Requirement"
              role.update(role: "no owner", user_id: nil) if role
            end
          end

          if jd.required_experiences.any? 
            jd.required_experiences.each do |req_exp|
              role = Role.find_by role: "owner", user_id: current_user.id, resource_id: req_exp.id, resource_type: "RequiredExperience"
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

  def transfer_ownership_to_jd_associated_resources(jd)
    if jd.qualifications.any?
      jd.qualifications.each do |qualification|
        if role_with_no_owner?(qualification.id, qualification.class.name)
          role = Role.find_by role: "no owner", resource_id: qualification.id, resource_type: qualification.class.name
          role.update(role: "owner", user_id: current_user.id) if role
        else  
          Role.create role: "owner", user_id: current_user.id, resource_id: qualification.id, resource_type: qualification.class.name unless Role
          .where(role: "owner", user_id: current_user.id, resource_id: qualification.id, resource_type: qualification.class.name).any?  
        end   
      end   
    end

    if jd.required_experiences.any? 
      jd.required_experiences.each do |req_exp|
        if role_with_no_owner?(req_exp.id, req_exp.class.name)
          role = Role.find_by role: "no owner", resource_id: req_exp.id, resource_type: req_exp.class.name 
          role.update(role: "owner", user_id: current_user.id) if role 
        else 
          Role.create role: "owner", user_id: current_user.id, resource_id: req_exp.id, resource_type: req_exp.class.name unless Role 
          .where(role: "owner", user_id: current_user.id, resource_id: req_exp.id, resource_type: req_exp.class.name).any?  
        end   
      end
    end

    if jd.requirements.any?
      jd.requirements.each do |requirement|
        if role_with_no_owner?(requirement.id, requirement.class.name)
          role = Role.find_by role: "no owner", resource_id: requirement.id, resource_type: requirement.class.name  
          role.update(role: "owner", user_id: current_user.id) if role 
        else
          Role.create role: "owner", user_id: current_user.id, resource_id: requirement.id, resource_type: requirement.class.name unless Role 
          .where(role: "owner", user_id: current_user.id, resource_id: requirement.id, resource_type: requirement.class.name).any?
        end 
      end
    end
  end
end
