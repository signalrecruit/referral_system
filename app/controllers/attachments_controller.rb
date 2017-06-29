class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def show 
    attachment = Attachment.find(params[:id])
    send_file attachment.file.path, disposition: :inline
  end	

  def new
    @job_description = JobDescription.new
    @job_description.attachments.build
    render layout: false	
  end

  def destroy
  	attachment = Attachment.find(params[:id])
  	attachment.destroy 
  	redirect_to :back
  end
end
