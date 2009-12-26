class CreateAuctions < ActiveRecord::Migration
  def self.up
    create_table :auctions do |t|
      t.integer :player_id
      t.integer :highest_id
      t.references :item, :polymorphic => true
      t.integer :num
      t.integer :money
      t.datetime :finish_at
      t.timestamps
    end
    add_index :auctions, :player_id
    add_index :auctions, :highest_id
  end

  def self.down
    drop_table :auctions
  end
end
