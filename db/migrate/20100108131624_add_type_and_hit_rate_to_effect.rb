class AddTypeAndHitRateToEffect < ActiveRecord::Migration
  def self.up
    add_column :effects, :type, :string
    add_column :effects, :hit_rate, :integer
  end

  def self.down
    remove_column :effects, :type
    remove_column :effects, :hit_rate
  end
end
