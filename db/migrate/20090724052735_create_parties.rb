class CreateParties < ActiveRecord::Migration
  def self.up
    create_table :parties do |t|
      t.string :name
      t.integer :adventurer_id,:null => false
    end
    add_index :parties, :adventurer_id
  end

  def self.down
    drop_table :parties
  end
end
