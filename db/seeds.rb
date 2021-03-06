# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create fullname: "Jide Otoki", email: "jide@mail.com", password: "password", password_confirmation: "password",
admin: true, admin_status: 2, phonenumber: "0000000000", username: "Super Admin", approval: true

User.create fullname: "Derek Owusu-Frimpong", email: "deepsky_5@live1.com", password: "password",
 password_confirmation: "password", admin: true, admin_status: 2, phonenumber: "0204704427", username: "Picaso", approval: true

User.create fullname: "Elliot Alderson", email: "elliot@alderson.com", password: "password",
 password_confirmation: "password", admin: false, admin_status: 0, phonenumber: "0000000000", username: "Mr. Robot", approval: true


User.create fullname: "Darlene Alderson", email: "darlene@alderson.com", password: "password",
 password_confirmation: "password", admin: false, admin_status: 0, phonenumber: "0000000000", username: "Darlene", approval: true

User.create fullname: "Aaron Patterson", email: "rubydev@email.com", password: "password", password_confirmation: "password", admin: true, 
admin_status: 3, phonenumber: "000000000", username: "tender love", approval: true


industries = ["Travel&Tours", "Retail/Wholesale", "Power/Energy", "Oil&amp/Mining", "Logistics/Transportation", "Legal/Insurance", "Food Services", "FMCG", "Engineering", 
 "Ecommerce/Internet", "Creative Art/Design", "Agric/Poultry/Fishing", "Advertising/Marketing/Communications", "Banking/Financial Services", "Construction/Real Estate", 
 "Consulting", "Education", "Government/Defense", "Healthcare", "Hospitality/Leisure", "ICT/Telecom", "Manufacturing/Production", "Media", "NGO", "Trade/Services", "Blue Collar",
 "Science/Research&Development"]

industries.each do |industry|
  Industry.create name: industry 
end