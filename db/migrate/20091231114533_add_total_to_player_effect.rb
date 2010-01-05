class AddTotalToPlayerEffect < ActiveRecord::Migration
  def self.up
    add_column :player_effects, :total,:integer, :default => 0
  end

  def self.down
    remove_column :player_effects, :total
  end
end
