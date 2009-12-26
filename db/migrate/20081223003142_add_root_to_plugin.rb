class AddRootToPlugin < ActiveRecord::Migration
  def self.up
    add_column :plugins,:root,:integer,:null => false,:default => 0
    add_index :plugins,:root
  end

  def self.down
    remove_index :plugins,:root
    remove_column :plugins,:root
  end
end
