class RequiredExperiencesController < ApplicationController
  before_action :authenticate_user!
  before_action :prevent_addition_of_new_required_experiences_if_jd_has_applicants, only: [:new, :create]
  before_action :copy_changes_to_existing_object, only: [:update]
  before_action :set_jd, except: [:update_button]
  before_action :set_experience, only: [:show, :edit, :update, :destroy]

  def index
  	@experiences = @jd.required_experiences.all
  end

  def show
  end

  def new
  	@experience = @jd.required_experiences.build
  end

  def create
  	@experience = @jd.required_experiences.build(exp_params)

  	if @experience.save 
      implement_authorization_policy_if_applicable @experience
      on_success "added qualification successfully", new_job_description_requirement_url(@jd) if params[:commit] == "Save and Next"
      on_success "added qualification successfully", [@jd.company, @jd] if params[:commit] == "Save"
  	else
      on_failure "oops! something went wrong", :new
  	end

  end

  def edit
  end

  def update
  	if @experience.update(exp_params)
  	  @experience.update(update_button: false) 	
      on_success "successufully updated an experience", :back
  	else
      on_failure "oops! something went wrong", :edit
  	end
  end

  def destroy
    delete_copy_of_resource @experience
  	@experience.destroy
    on_success "deletion successfully done", :back
  end

  def update_button
  	@experience = RequiredExperience.find(params[:id])
  	@experience.update(update_button: true)
  	redirect_to :back
  end


  private 

  def set_jd
  	@jd = JobDescription.find(params[:job_description_id])
  end

  def set_experience
  	set_jd 
  	@experience = @jd.required_experiences.find(params[:id])
  end

  def exp_params
  	params.require(:required_experience).permit(:experience, :years, :update_button)
  end

  def copy_changes_to_existing_object
    @experience = RequiredExperience.find(params[:id])
    if @experience.job_description.applicants.any?
      existing_attributes = @experience.attributes
      update_attributes = exp_params
      ["id", "job_description_id", "created_at", "updated_at", "copy", "copy_id", "update_button"].each do |key|
        existing_attributes.delete(key)
      end
      update_attributes["years"] = update_attributes["years"].to_i

      if change_in_data existing_attributes, update_attributes 
        if find_experience_copy = RequiredExperience.find_by(copy: true, copy_id: @experience.id)
          find_experience_copy.delete 
          @experience_copy = RequiredExperience.create exp_params
          @experience_copy.update(copy: true, copy_id: @experience.id, job_description_id: @experience.job_description_id)
        else
          @experience_copy = RequiredExperience.create exp_params
          @experience_copy.update(copy: true, copy_id: @experience.id, job_description_id: @experience.job_description_id)
        end
        flash[:warning] = "your changes have been saved pending admin authorization."
        @experience.update(update_button: false)
        redirect_to company_job_description_url(@experience.job_description.company, @experience.job_description)
      else 
        @experience.update(update_button: false)
        flash[:alert] = "no change in data detected"
        redirect_to company_job_description_url(@experience.job_description.company, @experience.job_description)
      end
    else  
      # @experience.job_description.update(update_button: false) 
      # @experience.update(update_button: false)
      # redirect_to company_job_description_url @experience.job_description.company, @experience.job_description
    end
  end

  def prevent_addition_of_new_required_experiences_if_jd_has_applicants
    @job_description = JobDescription.find(params[:job_description_id])
    if @job_description.applicants.any? 
      flash[:alert] = "you can not add new experiences since this job description has associated applicants"
      redirect_to :back
    end
  end
end
