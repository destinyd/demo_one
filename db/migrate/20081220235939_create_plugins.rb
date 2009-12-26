class CreatePlugins < ActiveRecord::Migration
  def self.up
    create_table :plugins do |t|
      t.string :name,:null => false
      t.text :description
      t.string :url,:null => false
      t.integer :can_change,:default => 1,:null => false
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :plugins
  end
end
