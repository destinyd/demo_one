class CreatePets < ActiveRecord::Migration
  def self.up
    create_table :pets do |t|
      t.integer :hp,:null => false
      t.string :type
      t.integer :player_id
      t.timestamps
    end
    add_index :pets, :player_id
  end

  def self.down
    drop_table :pets
  end
end
