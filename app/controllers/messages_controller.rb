class MessagesController < ApplicationController
  before_action :set_message, only: [:show]

  def index
    @messages = Message.all.where(recipient_id: current_user.id).order(created_at: :asc)
  end

  def show
  	@message.update(read: true)
  end


  private 

  def set_message
  	@message = Message.find(params[:id])
  end
end
