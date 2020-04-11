# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_11_224327) do

  create_table "pipelines", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "repo"
    t.string "triggers"
    t.string "domain"
  end

  create_table "runs", force: :cascade do |t|
    t.integer "num"
    t.datetime "completed_at"
    t.datetime "failed_at"
    t.string "output"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "pipeline_id"
    t.string "commit_sha"
    t.string "commit_message"
    t.index ["pipeline_id"], name: "index_runs_on_pipeline_id"
  end

  create_table "secrets", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.string "domain"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "runs", "pipelines"
end
