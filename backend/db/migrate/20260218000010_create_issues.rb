class CreateIssues < ActiveRecord::Migration[7.2]
  def change
    create_table :issues do |t|
      t.references :company, null: false, foreign_key: true
      t.references :job, null: false, foreign_key: { to_table: :inspection_jobs }
      t.string :title, null: false
      t.text :description
      t.string :severity, null: false, default: "medium"
      t.string :status, null: false, default: "open"
      t.datetime :reported_at, null: false
      t.datetime :resolved_at

      t.timestamps
    end

    add_index :issues, [ :company_id, :status, :reported_at ]
  end
end
