class CreateInspectionResults < ActiveRecord::Migration[7.2]
  def change
    create_table :inspection_results do |t|
      t.references :job, null: false, foreign_key: { to_table: :inspection_jobs }
      t.references :template_item, null: false, foreign_key: { to_table: :inspection_template_items }
      t.string :result_type, null: false
      t.string :result_value
      t.decimal :numeric_value, precision: 10, scale: 2
      t.text :comment

      t.timestamps
    end

    add_index :inspection_results, [ :job_id, :template_item_id ], unique: true
  end
end
