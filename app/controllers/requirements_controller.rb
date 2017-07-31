class RequirementsController < ApplicationController
  before_action :authenticate_user!
  before_action :copy_changes_to_existing_object, only: [:update]
  before_action :set_jd, except: [:update_button]
  before_action :set_requirement, only: [:show, :edit, :update, :destroy]

  def index
    @requirements = @jd.requirements.all	
  end

  def show
  end

  def new
    @requirement = @jd.requirements.new
  end

  def create
    @requirement = @jd.requirements.build(requirement_params)
    
    if @requirement.save 
      implement_authorization_policy_if_applicable @requirement
      on_success "successfully created a requirement", company_job_description_url(@jd.company, @jd)
    else
      on_failure "oops! sthg went wrong", :new
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
      @requirement.update(update_button: false)
      redirect_to company_job_description_url(@requirement.job_description.company, @requirement.job_description)
    else 
      @requirement.update(update_button: false)
      flash[:alert] = "no changes in data detected"
      redirect_to company_job_description_url(@requirement.job_description.company, @requirement.job_description)  
    end
  end
end
