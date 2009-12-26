class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
			t.string :name,:null =>false
			t.integer :money,:default=>10000,:limit => 20
			t.string :title,:default => ""
			t.string :signed,:default => ""
			t.integer :at
			t.integer :can_change,:default=>1
			t.integer :user_id,:null => false
    end
    add_index :players, :user_id
  end

  def self.down
    drop_table :players
  end
end
