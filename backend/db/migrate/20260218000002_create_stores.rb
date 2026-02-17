class CreateStores < ActiveRecord::Migration[7.2]
  def change
    create_table :stores do |t|
      t.references :property, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
