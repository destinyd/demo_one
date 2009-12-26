class CreateShops < ActiveRecord::Migration
  def self.up
    create_table :shops do |t|
      t.integer :item_id,:null => false
      t.integer :num,:null => false,:limit => 20
      t.integer :price,:null => false,:limit => 20
      t.integer :player_id,:null => false
      t.timestamps
    end
    add_index :shops, :player_id
  end

  def self.down
    drop_table :shops
  end
end
