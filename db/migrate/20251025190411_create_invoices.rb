class CreateInvoices < ActiveRecord::Migration[7.2]
  def change
    create_table :invoices do |t|
      t.references :user, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.string :number, null: false
      t.integer :status, null: false, default: 0 # draft
      t.string :currency, null: false, default: "USD"
      t.integer :total_cents, null: false, default: 0
      t.date :issued_on
      t.date :due_date, null: false
      t.datetime :paid_at
      t.string :stripe_checkout_session_id
      t.string :payment_url
      t.text :notes

      t.timestamps
    end

    add_index :invoices, [:user_id, :number], unique: true
    add_index :invoices, :status
    add_index :invoices, :due_date
  end
end
