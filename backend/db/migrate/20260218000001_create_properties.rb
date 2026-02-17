class CreateProperties < ActiveRecord::Migration[7.2]
  def change
    create_table :properties do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name, null: false
      t.string :address

      t.timestamps
    end
  end
end
