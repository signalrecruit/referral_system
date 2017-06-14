class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: [:show, :edit, :update, :destroy, :archive_message, :send_message, :unarchive_message]

  def index
    # @messages = Message.all.where(recipient_id: current_user.id, draft: false).order(created_at: :asc)
    if params[:category] == "received"
      @messages = Message.received_messages_for_user.where(recipient_id: current_user.id)
    elsif params[:category] == "sent"
      @messages = Message.sent_messages_for_user.where(user_id: current_user.id)
    elsif params[:category] == "draft"
      @messages = Message.drafted_by_user.where(user_id: current_user.id)
    elsif params[:category] == "archived"
      @messages = Message.messages_archived_by_user
    else 
      retrieve_all_messages   
    end  
  end

  def show
  	@message.update(read: true)
    set_reply_thread @message
    @message_id = params[:message_id].to_i
  end

  def new
    @message = Message.new
    @reply_id = params[:reply_id].to_i
    @reply_message = Message.find(@reply_id) 
    @recipient_id = @reply_message.recipient_id
    @recipient_email = User.find(@recipient_id).email 
    set_reply_thread @reply_message
  end

  def create
    @message = Message.new(message_params)
    @message.reply_id = params[:message][:reply_id]
    @message.title = params[:message][:title] 
    @message.recipient_name = params[:message][:recipient_name]
    @message.recipient_id = params[:message][:recipient_id]
    @message.user_id = params[:message][:user_id]
    @message.sent_by = params[:message][:sent_by]
    @reply_message = Message.find(@message.reply_id.to_i) 

    if @message.save
      flash[:success] = "reply successfully sent"
      redirect_to @message
    else
      flash[:alert] = "oops! something went wrong"
      set_reply_thread @reply_message
      render :new 
    end
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

  def send_message
    @message.update(draft: false)
    redirect_to admin_messages_url
  end

  def archive_message
    @message.update(archived_by_user: true)
    redirect_to :back
  end 

  def unarchive_message
    @message.update(archived_by_user: false)
    redirect_to :back 
  end



  private 

  def set_message
  	@message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:content, :recipient_id, :read, :title, :draft, :recipient_name, :reply_id, :sent_by)
  end

  def set_reply_thread(message)
    @reply_thread = []
    Message.where(recipient_id: current_user.id, user_id: message.user_id).each do |msg|
      @reply_thread << msg
    end
    Message.where(recipient_id: message.user_id, user_id: current_user.id).each do |msg|
      @reply_thread << msg
    end
    @reply_thread.sort! { |a, b| b.created_at <=> a.created_at }
  end

  def retrieve_all_messages
    @messages = []
    Message.where(recipient_id: current_user.id, archived: false).each do |msg|
      @messages << msg
    end
    Message.where(user_id: current_user.id, archived: false).each do |msg|
      @messages << msg 
    end
    @messages.sort! { |a, b| a.created_at <=> b.created_at }
  end
end
