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

  def updated?
  	return true if self.update_button?
  end
end
