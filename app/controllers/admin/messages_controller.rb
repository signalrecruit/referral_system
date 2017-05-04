class Admin::MessagesController < Admin::ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]	
  layout "admin"


  def index
  	@messages = Message.all.order(created_at: :asc)
  end

  def show
  end

  def new
  	@message = current_user.messages.build
  end

  def create
  	@message = current_user.messages.build(message_params) 

  	@message = find_recipient(@message)

  	if @message.save
  	  flash[:success] = "successfully sent #{@message.recipient_name}"
  	  redirect_to admin_messages_url	
  	else 	
  	  flash[:alert] = "oops! sthg went wrong"
  	  render :new	
  	end  	
  end

  def edit
  end


  private 

  def message_params
  	params.require(:message).permit(:recipient_name, :content, :title, :user_id, :recipient_id, :sent)
  end

  def find_recipient(message)
    user = User.find_by fullname: message.recipient_name
    recipient_id = user.id if user
    message.recipient_id = recipient_id
    @message = message
  end
end
