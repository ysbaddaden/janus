class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string   :email
      t.string   :encrypted_password
      
      t.string   :remember_token
      t.datetime :remember_created_at
      
      t.string   :session_token
    end
    
    add_index :users, :email,          :unique => true
    add_index :users, :remember_token, :unique => true
  end

  def self.down
    drop_table :users
  end
end
