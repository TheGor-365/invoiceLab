class CreateClients < ActiveRecord::Migration[7.2]
  def change
    create_table :clients do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :email, null: false
      t.string :locale, null: false, default: "en"
      t.string :timezone, null: false, default: "UTC"
      t.string :currency, null: false, default: "USD"
      t.text :note

      t.timestamps
    end

    add_index :clients, [:user_id, :email]
    add_index :clients, :locale
    add_index :clients, :timezone
    add_index :clients, :currency
  end
end
