# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170620144702) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.string   "action"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "permitted",      default: false
  end

  add_index "activities", ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id", using: :btree
  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

  create_table "applicant_records", force: :cascade do |t|
    t.integer  "job_description_id"
    t.string   "role"
    t.integer  "score_id"
    t.decimal  "applicant_score"
    t.integer  "comment_id"
    t.string   "feedback"
    t.integer  "applicant_id"
    t.string   "applicant_name"
    t.string   "applicant_status"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "company_name"
  end

  add_index "applicant_records", ["applicant_id"], name: "index_applicant_records_on_applicant_id", using: :btree
  add_index "applicant_records", ["comment_id"], name: "index_applicant_records_on_comment_id", using: :btree
  add_index "applicant_records", ["job_description_id"], name: "index_applicant_records_on_job_description_id", using: :btree
  add_index "applicant_records", ["score_id"], name: "index_applicant_records_on_score_id", using: :btree

  create_table "applicants", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phonenumber"
    t.string   "location"
    t.integer  "min_salary"
    t.integer  "max_salary"
    t.integer  "company_id"
    t.integer  "job_description_id"
    t.integer  "user_id"
    t.string   "attachment"
    t.boolean  "update_button",        default: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "status",               default: "none"
    t.decimal  "earnings",             default: 0.0
    t.decimal  "salary",               default: 0.0
    t.boolean  "update_salary",        default: false
    t.decimal  "percent_salary",       default: 0.0
    t.boolean  "update_salary_button", default: false
  end

  add_index "applicants", ["company_id"], name: "index_applicants_on_company_id", using: :btree
  add_index "applicants", ["job_description_id"], name: "index_applicants_on_job_description_id", using: :btree
  add_index "applicants", ["user_id"], name: "index_applicants_on_user_id", using: :btree

  create_table "bank_accounts", force: :cascade do |t|
    t.string   "account_holder"
    t.string   "account_number"
    t.string   "bank_name"
    t.string   "sort_code"
    t.text     "account_holder_address"
    t.integer  "user_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "update_button",          default: false
  end

  add_index "bank_accounts", ["user_id"], name: "index_bank_accounts_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "feedback"
    t.integer  "applicant_id"
    t.integer  "job_description_id"
    t.integer  "score_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "comments", ["applicant_id"], name: "index_comments_on_applicant_id", using: :btree
  add_index "comments", ["job_description_id"], name: "index_comments_on_job_description_id", using: :btree
  add_index "comments", ["score_id"], name: "index_comments_on_score_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "company_name"
    t.string   "clientname"
    t.string   "email"
    t.string   "role"
    t.string   "phonenumber"
    t.string   "url"
    t.text     "about"
    t.integer  "user_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "update_button", default: false
    t.boolean  "contacted",     default: false
    t.boolean  "deal",          default: false
    t.integer  "industry_id"
    t.string   "alias_name"
  end

  add_index "companies", ["industry_id"], name: "index_companies_on_industry_id", using: :btree
  add_index "companies", ["user_id"], name: "index_companies_on_user_id", using: :btree

  create_table "industries", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_descriptions", force: :cascade do |t|
    t.string   "job_title"
    t.integer  "experience"
    t.decimal  "min_salary"
    t.decimal  "max_salary"
    t.integer  "vacancies"
    t.boolean  "update_button"
    t.integer  "company_id"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.text     "role_description"
    t.integer  "number_of_applicants"
    t.decimal  "actual_worth",            default: 0.0
    t.decimal  "percent_worth",           default: 0.0
    t.integer  "user_id"
    t.decimal  "applicant_worth",         default: 0.0
    t.decimal  "applicant_percent_worth", default: 0.0
    t.decimal  "vacancy_worth",           default: 0.0
    t.decimal  "vacancy_percent_worth",   default: 0.0
    t.decimal  "earnings",                default: 0.0
    t.decimal  "potential_worth",         default: 0.0
    t.boolean  "completed",               default: false
    t.datetime "expiration_date",         default: '2017-06-19 14:48:25'
  end

  add_index "job_descriptions", ["company_id"], name: "index_job_descriptions_on_company_id", using: :btree
  add_index "job_descriptions", ["user_id"], name: "index_job_descriptions_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "content"
    t.string   "recipient_id"
    t.boolean  "read",             default: false
    t.integer  "user_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "title"
    t.boolean  "draft",            default: false
    t.string   "recipient_name"
    t.string   "sent_by"
    t.integer  "reply_id",         default: 0
    t.boolean  "archived",         default: false
    t.boolean  "archived_by_user", default: false
  end

  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.datetime "clicked_at"
    t.boolean  "clicked",           default: false
    t.string   "action"
    t.string   "notification_type"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "qualifications", force: :cascade do |t|
    t.string   "certificate"
    t.string   "field_of_study"
    t.integer  "job_description_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "update_button",      default: false
  end

  add_index "qualifications", ["job_description_id"], name: "index_qualifications_on_job_description_id", using: :btree

  create_table "required_experiences", force: :cascade do |t|
    t.string   "experience"
    t.integer  "years"
    t.integer  "job_description_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "update_button",      default: false
  end

  add_index "required_experiences", ["job_description_id"], name: "index_required_experiences_on_job_description_id", using: :btree

  create_table "requirement_scores", force: :cascade do |t|
    t.decimal  "score",               default: 0.0
    t.integer  "applicant_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "requirement_content"
    t.integer  "requirement_id"
    t.integer  "job_description_id"
  end

  add_index "requirement_scores", ["applicant_id"], name: "index_requirement_scores_on_applicant_id", using: :btree
  add_index "requirement_scores", ["job_description_id"], name: "index_requirement_scores_on_job_description_id", using: :btree
  add_index "requirement_scores", ["requirement_id"], name: "index_requirement_scores_on_requirement_id", using: :btree

  create_table "requirements", force: :cascade do |t|
    t.text     "content"
    t.boolean  "update_button"
    t.integer  "job_description_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "requirements", ["job_description_id"], name: "index_requirements_on_job_description_id", using: :btree

  create_table "scores", force: :cascade do |t|
    t.integer  "job_description_id"
    t.integer  "applicant_id"
    t.decimal  "applicant_score"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "scores", ["applicant_id"], name: "index_scores_on_applicant_id", using: :btree
  add_index "scores", ["job_description_id"], name: "index_scores_on_job_description_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",     null: false
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.boolean  "admin",                  default: false
    t.integer  "admin_status",           default: 0
    t.boolean  "update_button",          default: false
    t.string   "fullname"
    t.string   "phonenumber"
    t.string   "username"
    t.decimal  "cumulative_earnings",    default: 0.0
    t.boolean  "done",                   default: false
    t.boolean  "approval",               default: false
    t.string   "payment_option",         default: "none"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "activities", "users"
  add_foreign_key "applicant_records", "applicants"
  add_foreign_key "applicant_records", "comments"
  add_foreign_key "applicant_records", "job_descriptions"
  add_foreign_key "applicant_records", "scores"
  add_foreign_key "applicants", "companies"
  add_foreign_key "applicants", "job_descriptions"
  add_foreign_key "applicants", "users"
  add_foreign_key "bank_accounts", "users"
  add_foreign_key "comments", "applicants"
  add_foreign_key "comments", "job_descriptions"
  add_foreign_key "comments", "scores"
  add_foreign_key "companies", "users"
  add_foreign_key "job_descriptions", "companies"
  add_foreign_key "job_descriptions", "users"
  add_foreign_key "messages", "users"
  add_foreign_key "qualifications", "job_descriptions"
  add_foreign_key "required_experiences", "job_descriptions"
  add_foreign_key "requirement_scores", "applicants"
  add_foreign_key "requirement_scores", "job_descriptions"
  add_foreign_key "requirement_scores", "requirements"
  add_foreign_key "requirements", "job_descriptions"
  add_foreign_key "scores", "applicants"
  add_foreign_key "scores", "job_descriptions"
end
