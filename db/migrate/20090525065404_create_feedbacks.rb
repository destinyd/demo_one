class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|
      t.text :body,:null => false
      t.integer :player_id ,:null => false
      t.timestamps
    end
    add_index :feedbacks, :player_id
  end

  def self.down
    drop_table :feedbacks
  end
end
