class CreateAdventurers < ActiveRecord::Migration
  def self.up
    create_table :adventurers do |t|
      t.integer :hp,:default => 100,:null => false
      t.integer :mhp,:default => 100,:null => false
      t.integer :win,:default => 0,:null => false
      t.integer :lose,:default => 0,:null => false
      t.integer :kill,:default => 0,:null => false
      t.integer :job,:null => false
      t.integer :weapon_id
      t.integer :armor_id
      t.string :plus
      t.integer :player_id,:null => false
    end
    add_index :adventurers, :player_id
  end

  def self.down
    drop_table :adventurers
  end
end
