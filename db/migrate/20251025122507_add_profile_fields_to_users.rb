class AddProfileFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :locale,           :string,  default: "en",  null: false
    add_column :users, :timezone,         :string,  default: "UTC", null: false
    add_column :users, :default_currency, :string,  limit: 3, default: "USD", null: false
    add_column :users, :admin,            :boolean, default: false, null: false

    add_index  :users, :admin
    
    add_check_constraint :users, "char_length(default_currency) = 3", name: "users_default_currency_len"
  end
end
