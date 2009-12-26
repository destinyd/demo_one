class CreateWaits < ActiveRecord::Migration
  def self.up
    create_table :waits do |t|
      t.integer :adventurer_id
      t.integer :scene_id
      t.timestamps
    end
    add_index :waits, :adventurer_id
    add_index :waits, :scene_id
  end

  def self.down
    drop_table :waits
  end
end
