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

ActiveRecord::Schema.define(version: 20170312060817) do

  create_table "cart_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "quantity"
    t.integer  "item_id"
    t.string   "item_type"
    t.integer  "price_cents",    default: 0,     null: false
    t.string   "price_currency", default: "USD", null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "carts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "correction_links", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "story_id"
    t.integer  "correction_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "default_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.decimal  "image_price",                             precision: 12, scale: 3
    t.decimal  "pdf_price",                               precision: 12, scale: 3
    t.text     "image_use_license",         limit: 65535
    t.string   "confirmation_from_email"
    t.string   "home_main_images"
    t.text     "home_welcome_text",         limit: 65535
    t.string   "home_image_cat1_name"
    t.string   "home_image_cat1"
    t.string   "home_image_cat2_name"
    t.string   "home_image_cat2"
    t.string   "home_image_cat3_name"
    t.string   "home_image_cat3"
    t.string   "search_for_publish_status"
    t.string   "search_for_priority"
    t.string   "search_for_caption_text"
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
  end

  create_table "keywords", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "keywords_stories", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "story_id"
    t.integer "keyword_id"
    t.index ["keyword_id"], name: "index_keywords_stories_on_keyword_id", using: :btree
    t.index ["story_id"], name: "index_keywords_stories_on_story_id", using: :btree
  end

  create_table "locations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_locations_on_name", using: :btree
  end

  create_table "logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "user_id"
    t.integer  "story_id"
    t.integer  "story_image_id"
    t.integer  "plan_id"
    t.integer  "pdf_image_id"
    t.string   "log_action"
    t.string   "log_detail"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "order_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "order_id"
    t.integer  "item_id"
    t.integer  "quantity"
    t.integer  "price_cents",    default: 0,     null: false
    t.string   "price_currency", default: "USD", null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "obscure_uniq_identifier"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "last4"
    t.decimal  "amount",                  precision: 12, scale: 3
    t.boolean  "success"
    t.string   "authorization_code"
    t.string   "email"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  create_table "papers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pdf_images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.date     "pubdate"
    t.string   "publication"
    t.string   "section_letter"
    t.string   "section_name"
    t.integer  "page"
    t.integer  "plan_id"
    t.text     "pdf_text",           limit: 65535
    t.index ["page"], name: "index_pdf_images_on_page", using: :btree
    t.index ["plan_id"], name: "index_pdf_images_on_plan_id", using: :btree
    t.index ["pubdate", "publication", "page"], name: "date_pub_page", using: :btree
    t.index ["pubdate", "publication", "section_letter", "page"], name: "date_pub_letter_page", using: :btree
    t.index ["pubdate", "publication", "section_letter", "section_name", "page"], name: "date_pub_letter_name_page", using: :btree
    t.index ["pubdate"], name: "index_pdf_images_on_pubdate", using: :btree
    t.index ["publication"], name: "index_pdf_images_on_publication", using: :btree
    t.index ["section_letter"], name: "index_pdf_images_on_section_letter", using: :btree
  end

  create_table "plans", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "pub_name"
    t.string   "section_name"
    t.string   "import_pub_name"
    t.string   "import_section_name"
    t.string   "publication_type_id"
    t.string   "location_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "import_section_letter"
    t.index ["location_id"], name: "index_plans_on_location_id", using: :btree
    t.index ["pub_name"], name: "index_plans_on_pub_name", using: :btree
    t.index ["publication_type_id"], name: "index_plans_on_publication_type_id", using: :btree
    t.index ["section_name"], name: "index_plans_on_section_name", using: :btree
  end

  create_table "publication_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.integer  "sort_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "publications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "location_id"
    t.integer  "publication_type_id"
  end

  create_table "section_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sections", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "section_category_id"
  end

  create_table "site_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.text     "site_announcement",      limit: 65535
    t.boolean  "show_site_announcement"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.boolean  "show_delete_button"
  end

  create_table "stories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "hl1"
    t.date     "pubdate"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "page",             limit: 50
    t.string   "byline"
    t.text     "copy",             limit: 65535
    t.integer  "doc_id"
    t.string   "copyright_holder"
    t.string   "doc_name"
    t.integer  "publication_id"
    t.integer  "section_id"
    t.integer  "paper_id"
    t.string   "hl2"
    t.string   "tagline"
    t.text     "sidebar_body",     limit: 65535
    t.string   "project_group"
    t.string   "frontend_db"
    t.integer  "plan_id"
    t.string   "pageset_letter"
    t.string   "author"
    t.string   "origin"
    t.string   "deskname"
    t.string   "categoryname"
    t.string   "subcategoryname"
    t.text     "memo",             limit: 65535
    t.text     "notes",            limit: 65535
    t.datetime "expiredate"
    t.datetime "web_published_at"
    t.string   "related_stories"
    t.string   "web_hl1"
    t.string   "web_hl2"
    t.text     "web_text",         limit: 65535
    t.text     "toolbox2",         limit: 65535
    t.text     "toolbox3",         limit: 65535
    t.text     "toolbox4",         limit: 65535
    t.text     "toolbox5",         limit: 65535
    t.text     "web_summary",      limit: 65535
    t.string   "kicker"
    t.string   "videourl"
    t.string   "alternateurl"
    t.string   "map"
    t.text     "caption",          limit: 65535
    t.text     "htmltext",         limit: 65535
    t.boolean  "approved"
    t.string   "web_pubnum"
    t.index ["plan_id"], name: "index_stories_on_plan_id", using: :btree
    t.index ["project_group"], name: "index_stories_on_project_group", using: :btree
    t.index ["pubdate"], name: "index_stories_on_pubdate", using: :btree
  end

  create_table "story_images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "story_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "media_id"
    t.string   "media_name"
    t.integer  "media_height"
    t.integer  "media_width"
    t.string   "media_mime_type"
    t.string   "media_source"
    t.text     "media_printcaption",    limit: 65535
    t.string   "media_printproducer"
    t.text     "media_originalcaption", limit: 65535
    t.string   "media_byline"
    t.string   "media_project_group"
    t.string   "media_notes"
    t.string   "media_status"
    t.string   "media_type"
    t.string   "publish_status"
    t.text     "media_webcaption",      limit: 65535
    t.string   "byline_title"
    t.string   "deskname"
    t.string   "priority"
    t.datetime "created_date"
    t.datetime "last_refreshed_time"
    t.datetime "expire_date"
    t.index ["image_updated_at"], name: "index_story_images_on_image_updated_at", using: :btree
    t.index ["story_id"], name: "index_story_images_on_story_id", using: :btree
  end

  create_table "story_topics", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "story_id"
    t.integer  "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topics", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "identity"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.string   "role",                                      default: "View"
    t.integer  "search_count",                              default: 0
    t.string   "login"
    t.string   "name"
    t.text     "group_strings",               limit: 65535
    t.string   "ou_strings"
    t.integer  "default_location_id"
    t.integer  "default_publication_type_id"
    t.string   "default_publication"
    t.string   "default_section_name"
  end

end
