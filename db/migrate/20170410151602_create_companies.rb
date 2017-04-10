class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :company_name
      t.string :clientname
      t.string :email
      t.string :role
      t.string :phonenumber
      t.string :url
      t.text :about
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
