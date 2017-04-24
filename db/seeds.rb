# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create fullname: "Derek Owusu-Frimpong", email: "deepsky_5@live.com", password: "password",
 password_confirmation: "password", admin: true, admin_status: 2, phonenumber: "0204704427", username: "picaso"

User.create fullname: "Scarlet Johanson", email: "scarlet@user.com", password: "password",
 password_confirmation: "password", admin: false, admin_status: 0, phonenumber: "0000000000", username: "Scarlet"


User.create fullname: "Ruth Affram", email: "ruth@user.com", password: "password",
 password_confirmation: "password", admin: false, admin_status: 0, phonenumber: "0000000000", username: "Xose"


10.times do |i| 
  Industry.create name: "industry#{i}00"
end
