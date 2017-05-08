class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  def index
    @messages = Message.all.where(recipient_id: current_user.id, draft: false).order(created_at: :asc)
  end

  def show
  	@message.update(read: true)
  end

  def new
    @message = Message.new
    @reply_id = params[:reply_id].to_i
    @reply_message = Message.find(@reply_id) 
    @recipient_id = @reply_message.recipient_id
    @recipient_email = User.find(@recipient_id).email 
  end

  def create
    @message = Message.new(message_params)
    @message.reply_id = params[:message][:reply_id]
    @message.title = params[:message][:title] 
    @message.recipient_name = params[:message][:recipient_name]
    @message.recipient_id = params[:message][:recipient_id]
    @message.user_id = params[:message][:user_id]
    @reply_message = Message.find(@message.reply_id.to_i) 

    if @message.save
      flash[:success] = "reply successfully sent"
      redirect_to @message
    else
      flash[:alert] = "oops! something went wrong"
      render :new 
    end

    def edit
    end

    def update
      if @message.update(message_params)
        flash[:success] = "reply updated successfully."
        redirect_to :back 
      else
        flash[:alert] = "oops! something went wrong"
        render :edit
      end
    end

    def destroy
      @message.destroy
      flash[:success] = "message successfully deleted"
      redirect_to messages_url
    end
  end


  private 

  def set_message
  	@message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:content, :recipient_id, :read, :title, :draft, :recipient_name, :reply_id)
  end
end
