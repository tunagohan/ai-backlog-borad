class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.references :company, null: false, foreign_key: true
      t.string :level, null: false, default: "info"
      t.string :title, null: false
      t.text :message
      t.string :resource_type
      t.bigint :resource_id
      t.datetime :read_at

      t.timestamps
    end

    add_index :notifications, [ :company_id, :created_at ]
    add_index :notifications, [ :resource_type, :resource_id ]
  end
end
