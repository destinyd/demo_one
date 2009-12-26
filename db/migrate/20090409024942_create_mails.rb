class CreateMails < ActiveRecord::Migration
  def self.up
    create_table :mails do |t|
      t.string :title,:null => false
      t.string :body,:null => false
      t.string :from
      t.integer :to_id,:null => false
      t.timestamps
    end
    add_index :mails, :to_id
    add_index :mails, :from
  end

  def self.down
    drop_table :mails
  end
end
