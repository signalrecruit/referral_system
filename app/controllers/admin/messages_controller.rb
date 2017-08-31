class Admin::MessagesController < Admin::ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy, :send_message, :archive_message, :unarchive_message]	
  layout "admin"

  def index
  	if params[:category] == "received"
      @messages = Message.received_messages_for_admin(current_user)
      @x = "warning"
    elsif params[:category] == "sent"
      @messages = Message.sent_messages_for_admin.includes(:user).where(user_id: current_user.id)
      @x = "info"
    elsif params[:category] == "draft"
      @messages = Message.drafted_by_admin.includes(:user).where(user_id: current_user.id)
      @x = "default"
    elsif params[:category] == "archived"
      @messages = Message.messages_archived_by_admin(current_user)   
      @archived_messages = @messages   
      @x = "danger"
    else 
      retrieve_all_messages  
    end  
  end

  def show
    set_reply_thread @message
    @message_id = params[:message_id].to_i
  end

  def new
  	@message = current_user.messages.build
    
    # if URI(request.referrer).path == URI(admin_messages_url(category: "received")).path
    if params[:reply_id].to_i == 0
      @no_reply_target = session[:no_reply_target] = params[:reply_id].to_i  
    else  
      @reply_id = params[:reply_id].to_i
      @reply_message = Message.find(@reply_id) 
      @recipient_id = @reply_message.recipient_id
      @recipient_email = User.find(@recipient_id).email 
      set_reply_thread @reply_message
    end
  end

  def create
  	@message = current_user.messages.build(message_params) 
    
    if session[:no_reply_target] == params[:message][:no_reply_target].to_i
    else

      # refactor this piece of code 
      @message.reply_id = params[:message][:reply_id]
      @message.title = params[:message][:title] 
      @message.recipient_name = params[:message][:recipient_name]
      @message.recipient_id = params[:message][:recipient_id]
      @message.user_id = params[:message][:user_id]
      @message.sent_by = params[:message][:sent_by]
      @reply_message = Message.find(@message.reply_id.to_i) if params[:message][:reply_id]
    end

  	find_recipient(@message) if @reply_message.nil?

  	if @message.save
  	  flash[:success] = "successfully sent #{@message.recipient_name} a message."
  	  redirect_to :back
  	else 	
  	  flash[:alert] = "oops! your message was not delivered to #{@message.recipient_name} for the reason(s) below:"

      # refactor this piece of code
      @message.reply_id = params[:message][:reply_id]
      @message.title = params[:message][:title] 
      @message.recipient_name = params[:message][:recipient_name]
      @message.recipient_id = params[:message][:recipient_id]
      @message.user_id = params[:message][:user_id]
      @message.sent_by = params[:message][:sent_by]
      @reply_message = Message.find(@message.reply_id.to_i) if params[:message][:reply_id]
      set_reply_thread @reply_message if @reply_message

  	  render :new	
  	end  	
  end

  def edit
  end

  def update
  	if @message.update(message_params)
  	  flash[:success] = "successfully updated message"

  	  if request.referrer == edit_admin_message_url(@message, page: "from show")
  	  	redirect_to [:admin, @message]
  	  else
  	    redirect_to admin_messages_url(category: "received")
  	  end	
  	else
  	  flash[:alert] = "oops! something went wrong"
  	  render :edit
  	end
  end

  def destroy
  	@message.destroy
  	redirect_to admin_messages_url
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

  def message_params
  	params.require(:message).permit(:recipient_name, :content, :read, :title, :user_id, :recipient_id, :draft, :sent_by, :archived)
  end

  def find_recipient(message)
    user = User.find_by fullname: message.recipient_name
    recipient_id = user.id if user
    message.recipient_id = recipient_id
    message.sent_by = current_user.fullname << "(Admin)"
    @message = message
  end

  def set_message
    @message = Message.find(params[:id])
  end

  def set_reply_thread(message)
    @reply_thread ||= Message.where(archived: nil)
    @reply_thread = Message.where(recipient_id: current_user.id, user_id: message.user_id).all + 
    Message.where(recipient_id: message.user_id, user_id: current_user.id).all
    @reply_thread.sort!{ |a, b| b.updated_at <=> a.updated_at }
  end

  def retrieve_all_messages
    @messages ||= Message.where(archived: nil) #create an empty active record relation
    @messages = Message.where(recipient_id: current_user.id, archived: false).all
    Message.where(user_id: current_user.id, archived: false).all.each do |msg|
      @messages << msg 
    end
    @messages.includes(:user).order(created_at: :asc)
  end
end
