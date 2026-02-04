# frozen_string_literal: true
class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.bigint :user_id, null: false
      t.string :title, null: false
      t.text :message, null: false
      t.integer :notification_type, null: false
      t.datetime :read_at
      t.timestamps
    end

    add_index :notifications, :user_id
    add_index :notifications, :notification_type
    add_index :notifications, :read_at

    add_foreign_key :notifications, :users
  end
end