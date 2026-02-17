class CreateInspectionTemplateItems < ActiveRecord::Migration[7.2]
  def change
    create_table :inspection_template_items do |t|
      t.references :section, null: false, foreign_key: { to_table: :inspection_template_sections }
      t.string :name, null: false
      t.string :result_type, null: false
      t.string :unit
      t.integer :sort_order, null: false, default: 0
      t.boolean :required, null: false, default: true

      t.timestamps
    end
  end
end
