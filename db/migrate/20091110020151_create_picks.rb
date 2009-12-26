class CreatePicks < ActiveRecord::Migration
  def self.up
    create_table :picks do |t|
      t.integer :ctype
      t.integer :level, :default => 1
      t.integer :player_id
      t.datetime :picked_at
      t.timestamps
    end
    add_index :picks, :player_id
  end

  def self.down
    drop_table :picks
  end
end
