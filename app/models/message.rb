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
end
