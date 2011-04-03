class CreateRemoteTokens < ActiveRecord::Migration
  def self.up
    create_table :remote_tokens do |t|
      t.references :user
      t.string     :token
      t.datetime   :created_at
    end
    
    add_index :remote_tokens, :token, :unique => true
  end

  def self.down
    drop_table :remote_tokens
  end
end
