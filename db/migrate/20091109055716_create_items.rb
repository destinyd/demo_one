class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :type, :limit => 20
      t.integer :level
      t.string :property
      t.string :plus,:default => ""
      t.integer :player_id
      t.boolean :vip

      t.timestamps
    end
    add_index :items, :player_id
    add_index :items, :level
    add_index :items, :vip
  end

  def self.down
    drop_table :items
  end
end
