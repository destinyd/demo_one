class AddReadToMail < ActiveRecord::Migration
  def self.up
    add_column :mails, :isread, :boolean, :default => 0,:null => false
    add_index :mails, :isread
  end

  def self.down
    remove_index :mails, :isread
    remove_column :mails, :isread
  end
end
