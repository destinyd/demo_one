class AddPlusToFighter < ActiveRecord::Migration
  def self.up
    add_column :fighters,:plus,:string,:default => "",:null => false
  end

  def self.down
    remove_column :fighters,:plus
  end
end
