# frozen_string_literal: true

class CreateUsersAndJwtDenylist < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string  :phone
      t.integer :role, null: false, default: 0

      t.timestamps

      add_index :users, :email, unique: true
      add_index :users, :reset_password_token, unique: true
      add_index :users, :role

      create_table :jwt_denylists do |t|
        t.string :jti, null: false
        t.datetime :exp, null: false
        t.timestamps
      end

      add_token :jwt_denylists, :jti
    end
  end
end
