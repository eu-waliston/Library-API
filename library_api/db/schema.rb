# frozen_string_literal: true

ActiveRecord::Schema[7.0].define(version: 2023_01_01_000000) do
  enable_extension "plpgsql"

  create_table "authors", force: :cascade do |t|
    t.string "name", null: false
    t.text "bio"
    t.date "birth_date"
    t.date "death_date"
    t.string "nationality"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_authors_on_name"
  end

  create_table "book_copies", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.string "barcode", null: false
    t.integer "status", default: 0, null: false
    t.date "acquisition_date", null: false
    t.bigint "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["barcode"], name: "index_book_copies_on_barcode", unique: true
    t.index ["book_id"], name: "index_book_copies_on_book_id"
    t.index ["location_id"], name: "index_book_copies_on_location_id"
    t.index ["status"], name: "index_book_copies_on_status"
  end

  create_table "books", force: :cascade do |t|
    t.string "title", null: false
    t.string "isbn", null: false
    t.text "description"
    t.integer "publication_year"
    t.integer "pages"
    t.string "language"
    t.string "genre"
    t.string "cover_image"
    t.bigint "author_id"
    t.bigint "category_id"
    t.bigint "publisher_id"
    t.decimal "average_rating", precision: 3, scale: 2, default: "0.0"
    t.integer "total_reviews", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_books_on_author_id"
    t.index ["category_id"], name: "index_books_on_category_id"
    t.index ["isbn"], name: "index_books_on_isbn", unique: true
    t.index ["publisher_id"], name: "index_books_on_publisher_id"
    t.index ["title"], name: "index_books_on_title"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "fines", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "loan_id", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.integer "status", default: 0, null: false
    t.date "due_date", null: false
    t.datetime "paid_at"
    t.datetime "waived_at"
    t.string "payment_method"
    t.text "waiver_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["loan_id"], name: "index_fines_on_loan_id"
    t.index ["status"], name: "index_fines_on_status"
    t.index ["user_id"], name: "index_fines_on_user_id"
  end

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "loans", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "book_copy_id", null: false
    t.datetime "borrowed_at", null: false
    t.datetime "due_date", null: false
    t.datetime "returned_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_copy_id"], name: "index_loans_on_book_copy_id"
    t.index ["due_date"], name: "index_loans_on_due_date"
    t.index ["returned_at"], name: "index_loans_on_returned_at"
    t.index ["user_id"], name: "index_loans_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "message", null: false
    t.integer "notification_type", null: false
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_type"], name: "index_notifications_on_notification_type"
    t.index ["read_at"], name: "index_notifications_on_read_at"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "publishers", force: :cascade do |t|
    t.string "name", null: false
    t.text "address"
    t.string "website"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_publishers_on_name", unique: true
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "book_copy_id", null: false
    t.datetime "reserved_at", null: false
    t.datetime "expires_at", null: false
    t.datetime "fulfilled_at"
    t.datetime "canceled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_copy_id"], name: "index_reservations_on_book_copy_id"
    t.index ["canceled_at"], name: "index_reservations_on_canceled_at"
    t.index ["expires_at"], name: "index_reservations_on_expires_at"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "book_id", null: false
    t.integer "rating", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_reviews_on_book_id"
    t.index ["user_id", "book_id"], name: "index_reviews_on_user_id_and_book_id", unique: true
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone"
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "book_copies", "books"
  add_foreign_key "books", "authors"
  add_foreign_key "books", "categories"
  add_foreign_key "books", "publishers"
  add_foreign_key "fines", "loans"
  add_foreign_key "fines", "users"
  add_foreign_key "loans", "book_copies"
  add_foreign_key "loans", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "reservations", "book_copies"
  add_foreign_key "reservations", "users"
  add_foreign_key "reviews", "books"
  add_foreign_key "reviews", "users"
end