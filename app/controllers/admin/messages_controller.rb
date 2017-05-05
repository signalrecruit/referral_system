class Admin::MessagesController < Admin::ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy, :send_message]	
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

  def update
  	if @message.update(message_params)
  	  flash[:success] = "successfully updated message"

  	  if request.referrer == edit_admin_message_url(@message, page: "from show")
  	  	redirect_to [:admin, @message]
  	  else
  	    redirect_to admin_messages_url
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


  private 

  def message_params
  	params.require(:message).permit(:recipient_name, :content, :title, :user_id, :recipient_id, :draft)
  end

  def find_recipient(message)
    user = User.find_by fullname: message.recipient_name
    recipient_id = user.id if user
    message.recipient_id = recipient_id
    @message = message
  end

  def set_message
    @message = Message.find(params[:id])
  end
end
