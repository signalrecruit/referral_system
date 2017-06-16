class Admin::CommentsController < Admin::ApplicationController
  before_action :set_applicant	
  before_action :set_comments, only: [:show, :edit, :update, :destroy]
  layout "admin"

  def index
  end

  def show
  end

  def new
    @comment = @applicant.comments.new

    @comment.score_id = (Score.find_by job_description_id: @applicant.job_description_id).id
  	@comment.job_description_id = @applicant.job_description_id
  end

  def create
  	@comment = @applicant.comments.build(comment_params)
    
    @comment.score_id = (Score.find_by job_description_id: @applicant.job_description_id).id
  	@comment.job_description_id = @applicant.job_description_id

  	if @comment.save 
  	  flash[:success] = "feedback recorded successfully!"
  	  redirect_to :back 
  	else 
  	  flash[:alert] = "oops! something went wrong"
  	  render :new 	
  	end
  end

  def edit
  end

  def update
  	if @comment.update(comment_params)
  	  flash[:success] = "feedback updated successfully!"
  	  redirect_to :back 
  	else 
  	  flash[:alert] = "oops! something went wrong"
  	  render :edit	
  	end
  end

  def destroy
  	@comment.destroy 
  	flash[:success] = "successfully deleted feedback"
  	redirect_to :back
  end


  
  private

  def comment_params
    params.require(:comment).permit(:feedback, :applicant_id, :job_description_id, :score_id)
  end

  def set_applicant
  	@applicant = Applicant.find(params[:applicant_id])
  end

  def set_comment
  	set_applicant
  	@comment = @applicant.comments.find(params[:id])
  end
end
