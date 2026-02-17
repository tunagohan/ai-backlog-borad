class CreateSpaces < ActiveRecord::Migration[7.2]
  def change
    create_table :spaces do |t|
      t.references :store, null: false, foreign_key: true
      t.string :name, null: false
      t.string :floor_label

      t.timestamps
    end
  end
end
