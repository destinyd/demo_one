class CreateNames < ActiveRecord::Migration
  def self.up
    create_table :names do |t|
      t.string :name,:limit => 96,:null => false
      t.references :nameable,:polymorphic => true
      t.integer :player_id
      t.boolean :isnamed, :null => false, :default => false
      t.timestamps
    end
    add_index :names, :player_id
    add_index :names, :isnamed
  end

  def self.down
    drop_table :names
  end
end
