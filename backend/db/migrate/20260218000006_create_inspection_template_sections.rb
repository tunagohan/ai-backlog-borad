class CreateInspectionTemplateSections < ActiveRecord::Migration[7.2]
  def change
    create_table :inspection_template_sections do |t|
      t.references :template, null: false, foreign_key: { to_table: :inspection_templates }
      t.string :name, null: false
      t.integer :sort_order, null: false, default: 0

      t.timestamps
    end
  end
end
