class CreateFighters < ActiveRecord::Migration
  def self.up
    create_table :fighters do |t|
      t.integer :hp,:null => false
      t.integer :mhp,:null => false
      t.integer :job,:null => false
      t.integer :weapon_id
      t.integer :armor_id
      t.string  :action
      t.integer :side,:default => 0,:null => false
      t.boolean :over,:default => false,:null => false
      t.integer :scene_id,:null => false
      t.integer :adventurer_id,:null => false
      t.timestamps
    end
    add_index :fighters, :adventurer_id
    add_index :fighters, :scene_id
  end

  def self.down
    drop_table :fighters
  end
end
