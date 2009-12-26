class RemoveNameFromAll < ActiveRecord::Migration
  def self.up
    remove_column :pets, :name,:isnamed
    remove_column :players, :name
  end

  def self.down
    add_column :pets, :name ,:string
    add_column :pets, :isnamed,:boolean
    add_column :players, :name ,:string
  end
end
