class CreateInspectionTemplates < ActiveRecord::Migration[7.2]
  def change
    create_table :inspection_templates do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :version, null: false, default: 1
      t.boolean :is_active, null: false, default: true

      t.timestamps
    end

    add_index :inspection_templates, [ :company_id, :name, :version ], unique: true
  end
end
