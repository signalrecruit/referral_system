class User < ActiveRecord::Base
  include UserStatistics
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum admin_status: [:user, :normal_admin, :super_admin]
  has_many :companies, dependent: :destroy
  has_many :activities, as: :trackable, dependent: :destroy
  has_many :applicants, dependent: :destroy
  has_many :job_descriptions, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :bank_accounts, dependent: :destroy
  
  before_create :unique_username_generation


  def updated?
  	return true if self.update_button?
  end

  def profile_completed?
    return true if self.done?
  end

  def approved?
    return true if self.approval?
  end

  def disapproved?
    return true if !self.approval?
  end

  def unique_username_generation
    bool_val =  self.class.where(username: self.username).any?
    if bool_val
      self.username << "-#{SecureRandom.hex(2)}"
    end
  end
end
