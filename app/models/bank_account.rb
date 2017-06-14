class BankAccount < ActiveRecord::Base
  belongs_to :user
  validates :account_holder, :account_number, :bank_name, :sort_code, :account_holder_address, presence: true

  def updated?
    return true if self.update_button?
  end
end
