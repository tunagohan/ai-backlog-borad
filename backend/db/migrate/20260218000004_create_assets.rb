class CreateAssets < ActiveRecord::Migration[7.2]
  def change
    create_table :assets do |t|
      t.references :space, null: false, foreign_key: true
      t.string :name, null: false
      t.string :category
      t.string :serial_number
      t.date :installed_on
      t.string :status

      t.timestamps
    end
  end
end
