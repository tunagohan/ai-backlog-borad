class CreateInspectionJobs < ActiveRecord::Migration[7.2]
  def change
    create_table :inspection_jobs do |t|
      t.references :company, null: false, foreign_key: true
      t.references :template, null: false, foreign_key: { to_table: :inspection_templates }
      t.string :target_type, null: false
      t.bigint :target_id, null: false
      t.datetime :scheduled_for, null: false
      t.string :status, null: false, default: "scheduled"
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end

    add_index :inspection_jobs, [ :company_id, :status, :scheduled_for ]
  end
end
