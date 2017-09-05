# README


# Project Name: Referral System

# Brief Description
 * [Brief Description Here](https://github.com/signalrecruit/referral_system/blob/master/app_description.md)



# Ruby and Rails Versions

* ruby 2.2.1p85

* Rails 4.2.5.1


# System Dependencies

* check [Here](https://github.com/signalrecruit/referral_system/blob/master/Gemfile)

# App Configuration and Setup

* NOTE: you must have the following installed:

* [ruby(2.2.1p85) installation here](https://www.ruby-lang.org/en/downloads/)

* [rails(4.2.5.1) installation here](http://railsinstaller.org/en)

* [how to setup rails with postgres here](https://www.digitalocean.com/community/tutorials/how-to-setup-ruby-on-rails-with-postgres) OR
[here](https://www.digitalocean.com/community/tutorials/how-to-use-postgresql-with-your-ruby-on-rails-application-on-ubuntu-14-04)

# Getting Started

* run the following commands:

```
  mkdir app_dir

  cd app_dir

  git clone https://github.com/paa-yaw/referralsystem.git
  
  cd app_dir/referralsystem

  bundle install

  bin/rails s

```  
# User Credentials
  * [check here](https://github.com/signalrecruit/referral_system/blob/master/app_description.md#user-credentials)


# Database initialization

* NOTE: you must already have postgres setup with rails
* In your database.yml setup your username and password for development and production using environment variables like so:

```
  
development:
  <<: *default
  database: referral_system_development
  username: <%= ENV['REFERRAL_SYSTEM_USERNAME'] %>
  password: <%= ENV['REFERRAL_SYSTEM_DATABASE_PASSWORD'] %>
  host: localhost

production:
  <<: *default
  database: referral_system_production
  username: referral_system
  password: <%= ENV['REFERRAL_SYSTEM_DATABASE_PASSWORD'] %>



```

 
# No Test Suite Available

# License  

MIT License

Copyright (c) [2017] [Paa Yaw](https://github.com/paa-yaw)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

