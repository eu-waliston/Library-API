# frozen_string_literal: true

class CreateAuthorsCategoriesPublishers < ActiveRecord::Migration[7.0]
  def change
    create_table  :authors do |t|
      t.string  :name, null: false
      t.text    :bio
      t.date    :birth_date
      t.date    :death_year
      t.string  :nationality
      t.timestamps
    end

    add_index :authors, :name

    create_table  :categories do |t|
      t.string  :name, null: false
      t.text    :description
      t.timestamps
    end

    create_table  :publishers do |t|
      t.string  :name, null: false
      t.text    :address
      t.string  :website
      t.string  :phone
      t.timestamps
    end

    add_index :publishers, :name, unique: true
  end
end
