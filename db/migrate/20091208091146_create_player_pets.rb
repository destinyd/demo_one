class CreatePlayerPets < ActiveRecord::Migration
  def self.up
    create_table :player_pets do |t|
      t.integer :hp,:null => false
      t.integer :food,:null => false
      t.integer :happy,:null => false
      t.boolean :pray
      t.string  :needs
      t.integer :pet_id,:null => false
      t.integer :player_id,:null => false
      t.datetime :grow_at
      t.timestamps
    end
    add_index :player_pets, :player_id
    add_index :player_pets, :pet_id
  end

  def self.down
    drop_table :player_pets
  end
end
