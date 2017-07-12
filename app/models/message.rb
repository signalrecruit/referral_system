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
    Message.where(archived: false).joins(:user).where(users: { admin: false })
  end

  def self.received_messages_for_user
    Message.where(archived_by_user: false).joins(:user).where(users: { admin: true })
  end



  def self.sent_messages_for_admin
    Message.where(draft: false, archived: false).joins(:user).where(users: { admin: true })
  end

  def self.sent_messages_for_user
    Message.where(draft: false, archived_by_user: false).joins(:user).where(users: { admin: false })  
  end



  def self.drafted_by_admin
    Message.where(draft: true, archived: false).joins(:user).where(users: { admin: true })
  end

  def self.drafted_by_user
    Message.where(draft: true, archived_by_user: false).joins(:user).where(users: { admin: false })
  end



  def self.messages_archived_by_admin
    @messages = []
    Message.where(archived: true).joins(:user).where(users: { admin: true }).each do |message|
      @messages << message
    end
    Message.where(archived: true).joins(:user).where(users: { admin: false }).each do |message|
      @messages << message
    end
    @messages
  end

  def self.messages_archived_by_user
    @messages = []
    Message.where(archived_by_user: true).joins(:user).where(users: { admin: true }).each do |message|
      @messages << message
    end
    Message.where(archived_by_user: true).joins(:user).where(users: { admin: false }).each do |message|
      @messages << message
    end
    @messages
  end
end
