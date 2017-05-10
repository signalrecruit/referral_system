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

  def self.received_messages_for_admin
    Message.joins(:user).where(users: { admin: false })
  end

  def self.sent_messages_for_admin
    Message.joins(:user).where(users: { admin: true })
  end
end
