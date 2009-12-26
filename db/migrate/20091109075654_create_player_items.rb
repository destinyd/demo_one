class CreatePlayerItems < ActiveRecord::Migration
  def self.up
    create_table :player_items do |t|
      t.integer :player_id
      t.integer :item_id
      t.integer :amount
      t.boolean :lock
    end
    add_index :player_items, :player_id
    add_index :player_items, :item_id
    add_index :player_items, :lock
  end

  def self.down
    drop_table :player_items
  end
end
