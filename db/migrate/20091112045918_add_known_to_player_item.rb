class AddKnownToPlayerItem < ActiveRecord::Migration
  def self.up
    add_column :player_items, :known, :boolean
    add_index :player_items, :known
  end

  def self.down
    remove_index :player_items, :known
    remove_column :player_items, :known
  end
end
