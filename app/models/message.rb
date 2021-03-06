class Message < ActiveRecord::Base
  belongs_to :user

  validates :recipient_name, :content, :title, presence: true

  def save_as_draft?
  	return true if self.draft?
  	return false if !self.draft?
  end

  def read_message?
  	return true if self.read?
  	return false if !self.read?
  end

  def self.received_messages_for_admin(current_user)
    Message.where(archived: false, draft: false, recipient_name: "Admin(#{current_user.fullname})").all
  end

  def self.received_messages_for_user(current_user)
   Message.where(recipient_name: current_user.fullname, draft: false).all
  end



  def self.sent_messages_for_admin
    Message.where(draft: false, archived: false)
  end

  def self.sent_messages_for_user
    Message.where(draft: false)
  end



  def self.drafted_by_admin
    Message.where(draft: true, archived: false)
  end

  def self.drafted_by_user(current_user)
    Message.where(draft: true, archived: false, sent_by: "#{current_user.fullname}").all 
  end



  def self.messages_archived_by_admin(current_user)
    Message.where(archived: true, archived_by: current_user.fullname, sent_by: "#{current_user.fullname}(Admin)").all + 
    Message.where(archived: true, archived_by: current_user.fullname, recipient_name: "Admin(#{current_user.fullname})").all
  end

  def self.messages_archived_by_user(current_user)
    Message.where(archived: true, archived_by: current_user.fullname, sent_by: "#{current_user.fullname}").all + 
    Message.where(archived: true, archived_by: current_user.fullname, recipient_name: "#{current_user.fullname}").all
  end
end
