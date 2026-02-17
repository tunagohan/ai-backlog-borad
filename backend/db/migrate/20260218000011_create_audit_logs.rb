class CreateAuditLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :audit_logs do |t|
      t.references :company, foreign_key: true
      t.bigint :actor_user_id
      t.string :action, null: false
      t.string :resource_type, null: false
      t.bigint :resource_id
      t.json :metadata

      t.timestamps
    end

    add_index :audit_logs, [ :company_id, :created_at ]
    add_index :audit_logs, [ :resource_type, :resource_id ]
  end
end
