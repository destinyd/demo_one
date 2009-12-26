class CreateScenes < ActiveRecord::Migration
  def self.up
    create_table :scenes do |t|
      t.integer :scene,:null => false,:default => 0
      t.integer :round,:null => false,:default => 1
      t.boolean :over,:null => false,:default => false
      t.text :output
      t.timestamps
    end
  end

  def self.down
    drop_table :scenes
  end
end
