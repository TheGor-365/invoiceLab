class CreateEmailLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :email_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :invoice, null: false, foreign_key: true
      t.string :kind, null: false # created/due/overdue/paid
      t.string :to, null: false
      t.string :subject, null: false
      t.integer :status, null: false, default: 0 # queued/sent/failed
      t.string :message_id
      t.text :error
      t.datetime :sent_at
      t.timestamps
    end
    add_index :email_logs, [:invoice_id, :kind, :created_at]
  end
end
