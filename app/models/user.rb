class User < ActiveRecord::Base
  include UserStatistics
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  enum admin_status: [:user, :normal_admin, :super_admin, :dev]

  has_many :companies, dependent: :destroy
  has_many :activities, as: :trackable, dependent: :destroy
  has_many :applicants, dependent: :destroy
  has_many :job_descriptions, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :bank_accounts, dependent: :destroy
  has_many :notifications, foreign_key: :recipient_id
  has_many :roles, dependent: :destroy

  validates :username, :fullname, :phonenumber, presence: true
  validates :phonenumber, format: { with: /\A[-+]?[0-9]*\.?[0-9]+\Z/, message: "only allows numbers" }

  
  before_create :unique_username_generation


  def updated?
  	self.update_button?
  end

  def profile_completed?
    self.done?
  end

  def approved?
    self.approval?
  end

  def disapproved?
    !self.approval?
  end

  def unique_username_generation
    bool_val =  self.class.where(username: self.username).any?
    if bool_val
      self.username << "-#{SecureRandom.hex(2)}"
    end
  end
end
