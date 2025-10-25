class CreateInvoiceItems < ActiveRecord::Migration[7.2]
  def change
    create_table :invoice_items do |t|
      t.references :invoice, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.decimal :quantity, precision: 10, scale: 2, null: false, default: 1.0
      t.integer :unit_price_cents, null: false, default: 0
      t.integer :total_cents, null: false, default: 0

      t.timestamps
    end
  end
end
