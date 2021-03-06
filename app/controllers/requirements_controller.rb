class RequirementsController < ApplicationController
  before_action :authenticate_user!
  before_action :prevent_addition_of_new_requirements_if_jd_has_applicants, only: [:new, :create]
  before_action :prevent_deletion_of_requirements_if_jd_has_applicants, only: [:destroy]
  before_action :copy_changes_to_existing_object, only: [:update]
  before_action :set_jd, except: [:update_button]
  before_action :set_requirement, only: [:show, :edit, :update, :destroy]

  def index
    @requirements = @jd.requirements.where(copy: false).all	
  end

  def show
  end

  def new
    @requirement = @jd.requirements.new
  end

  def create
    @requirement = @jd.requirements.build(requirement_params)

    if params[:commit] == "proceed later"
      if @requirement.content.blank?
        redirect_to [@jd.company, @jd]
      else
        if @requirement.save 
          implement_authorization_policy_if_applicable @requirement
          on_success "your requirement was saved", [@jd.company, @jd]
        else
          on_failure "oops! something went wrong", :new
        end  
      end
    elsif params[:commit] == "Save"
      if @requirement.save 
        implement_authorization_policy_if_applicable @requirement
        on_success "added qualification successfully", [@jd.company, @jd] 
      else
        on_failure "oops! something went wrong for the reasons below", :new
      end
    elsif params[:commit] == "Save and Add Another Requirement"
      if @requirement.save 
        implement_authorization_policy_if_applicable @requirement 
        on_success "added compulsory requirement successfully", new_job_description_requirement_url(@jd) 
      else
        on_failure "oops! you can't add another compulsory requirement for the reasons below:", :new
      end   
    elsif params[:commit] == "done"
      if @requirement.content.blank?
        redirect_to [@jd.company, @jd]
      else
        if @requirement.save 
          implement_authorization_policy_if_applicable @requirement 
          redirect_to [@jd.company, @jd]
        else
          on_failure "oops! something went wrong for the reasons below", :new
        end
      end         
    end
  end

  def edit
  end

  def update
    if @requirement.update(requirement_params)
      @requirement.update(update_button: false)
      on_success "successfully updated a requirement", :back
    else
      on_failure "ooops! sthg went wrong", :back
    end 
  end

  def destroy
    delete_copy_of_resource @requirement
    @requirement.destroy
    on_success "requirement successfully deleted", :back
  end

  def update_button
    @requirement = Requirement.find(params[:id])
    @requirement.update(update_button: true)
    redirect_to :back
  end



  private

  def set_jd
    @jd = JobDescription.find(params[:job_description_id])	
  end

  def set_requirement
  	set_jd
  	@requirement = @jd.requirements.find(params[:id])
  end

  def requirement_params
  	params.require(:requirement).permit(:content)
  end

  def copy_changes_to_existing_object
    @requirement = Requirement.find(params[:id])
    if @requirement.job_description.applicants.any?
      existing_attributes = @requirement.attributes
      update_attributes = requirement_params
      ["id", "job_description_id", "created_at", "updated_at", "copy", "copy_id", "update_button"].each do |key|
        existing_attributes.delete(key)
      end

      if change_in_data existing_attributes, update_attributes 
        if find_requirement_copy = Requirement.find_by(copy: true, copy_id: @requirement.id)
          find_requirement_copy.delete  
          @requirement_copy = Requirement.create requirement_params 
          @requirement_copy.update(copy: true, copy_id: @requirement.id, job_description_id: @requirement.job_description_id)  
        else
          @requirement_copy = Requirement.create requirement_params 
          @requirement_copy.update(copy: true, copy_id: @requirement.id, job_description_id: @requirement.job_description_id)
        end
        flash[:warning] = "your changes have been saved pending admin authorization."
        @requirement.update(update_button: false)
        redirect_to company_job_description_url(@requirement.job_description.company, @requirement.job_description)
      else 
        @requirement.update(update_button: false)
        flash[:alert] = "no changes in data detected"
        redirect_to company_job_description_url(@requirement.job_description.company, @requirement.job_description)  
      end
    else
      # @requirement.job_description.update(update_button: false) 
      # redirect_to company_job_description_url @requirement.job_description.company, @requirement.job_description
    end
  end

  def prevent_addition_of_new_requirements_if_jd_has_applicants
    @job_description = JobDescription.find(params[:job_description_id])
    if @job_description.applicants.any? 
      flash[:alert] = "you can not add new requirements since this job description has associated applicants. However, you can make edits to existing requirements."
      redirect_to :back
    end
  end

  def prevent_deletion_of_requirements_if_jd_has_applicants
    @job_description = JobDescription.find(params[:job_description_id])
    if @job_description.applicants.any? 
      flash[:alert] = "you can not delete any requirements since this job description has associated applicants. However, you can make edits to existing requirements."
      redirect_to :back
    end
  end
end
