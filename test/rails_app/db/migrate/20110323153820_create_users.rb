class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string   :email
      t.string   :encrypted_password

      t.string   :remember_token
      t.datetime :remember_created_at

      t.string   :confirmation_token
      t.datetime :confirmation_sent_at
      t.datetime :confirmed_at

      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      t.string   :session_token

      t.integer :sign_in_count, :default => 0
      t.string  :last_sign_in_at
      t.string  :last_sign_in_ip
      t.string  :current_sign_in_at
      t.string  :current_sign_in_ip
    end

    add_index :users, :email,                :unique => true
    add_index :users, :remember_token,       :unique => true
    add_index :users, :reset_password_token, :unique => true
  end

  def self.down
    drop_table :users
  end
end
