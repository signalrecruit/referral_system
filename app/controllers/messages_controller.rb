class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: [:show, :edit, :update, :destroy, :archive_message, :send_message, :unarchive_message]

  def index
    # @messages = Message.all.where(recipient_id: current_user.id, draft: false).order(created_at: :asc)
    if params[:category] == "received"
      @messages = Message.received_messages_for_user(current_user)
      @x = "warning"
    elsif params[:category] == "sent"
      @messages = Message.sent_messages_for_user.where(user_id: current_user.id)
      @x = "info"
    elsif params[:category] == "draft"
      @messages = Message.drafted_by_user(current_user)
      @x = "default"
    elsif params[:category] == "archived"
      @messages = Message.messages_archived_by_user(current_user) 
      @x = "danger"    
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
    if @reply_id == 0 || @reply_id.nil?

      # when user needs to notify admin or wants to send admin a message
      @message.user_id = current_user.id 

      admin_array = User.all.where(admin: true)
      @message.recipient_id = @recipient_id = (admin_array[rand(0..(admin_array.length)-1)]).id
      @message.recipient_name = "Admin(#{User.find(@recipient_id).fullname})"
      
      @message.sent_by = current_user.fullname
    else
      # when user wants to reply a message from admin
      @reply_message = Message.find(@reply_id) 
      @recipient_id = @reply_message.recipient_id
      @recipient_email = User.find(@recipient_id).email 
      set_reply_thread @reply_message
    end
  end

  def create
      @message = Message.new(message_params)
    if @reply_id == 0 || @reply_id.nil?  
      # when user want to notify admin or wants to send admin a message
      @message.user_id = current_user.id 

      admin_array = User.all.where(admin: true)
      @message.recipient_id = params[:message][:recipient_id]

      @message.recipient_name = "Admin(#{User.find(@message.recipient_id).fullname})"
      
      @message.sent_by = current_user.fullname
    else  
      # when user wants to reply a message from admin
      @message.reply_id = params[:message][:reply_id]
      @message.title = params[:message][:title] 
      @message.recipient_name = params[:message][:recipient_name]
      @message.recipient_id = params[:message][:recipient_id]
      @message.user_id = params[:message][:user_id]
      @message.sent_by = params[:message][:sent_by]
      @reply_message = Message.find(@message.reply_id.to_i) 
    end

    if @message.save
      on_success "reply successfully sent", @message
    else
      if @reply_id == 0 || @reply_id.nil?
        flash[:alert] = "oops! something went wrong"
        @message.recipient_name = "Admin"
        render :new
      else        
        flash[:alert] = "oops! something went wrong"
        set_reply_thread @reply_message
        render :new
      end 
    end
  end

  def edit
  end

  def update
    if @message.update(message_params)
      on_success "reply updated successfully.", :back
    else
      on_failure "oops! something went wrong", :edit
    end
  end

  def destroy
    @message.destroy
    on_success "message successfully deleted", messages_url
  end

  def send_message
    @message.update(draft: false)
    redirect_to admin_messages_url
  end

  def archive_message
    @message.update(archived: true, archived_by: current_user.fullname, unarchived_by: nil)
    redirect_to :back
  end 

  def unarchive_message
    @message.update(archived: false, unarchived_by: current_user.fullname, archived_by: nil)
    redirect_to :back 
  end



  private 

  def set_message
  	@message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:content, :recipient_id, :read, :title, :draft, :recipient_name, :reply_id, :sent_by, :archived, :archived_by, :unarchived_by)
  end

  def set_reply_thread(message)
    @reply_thread ||= Message.where(archived: nil) #create an empty active record relation
    @reply_thread = Message.where(recipient_id: current_user.id, user_id: message.user_id).all +
    Message.where(recipient_id: message.user_id, user_id: current_user.id).all
    @reply_thread.sort!{ |a, b| b.updated_at <=> a.updated_at }
  end

  def retrieve_all_messages
    @messages ||= Message.where(archived: nil) #create an empty active record relation
    @messages = Message.where(recipient_id: current_user.id, archived: false).all
    Message.where(user_id: current_user.id, archived: false).each do |msg|
      @messages << msg 
    end
    @messages.includes(:user).order(created_at: :asc)
  end
end
