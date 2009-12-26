class CreatePets < ActiveRecord::Migration
  def self.up
    create_table :pets do |t|
      t.integer :hp,:null => false
      t.string :type
      t.integer :player_id
      t.timestamps
    end
    add_index :pets, :player_id
    OreElement.create(:name => "矿精",:hp=>100)
    WoodElement.create(:name => "阿童木",:hp=>100)
    Beast.create(:name => "皮球",:hp=>100)
  end

  def self.down
    drop_table :pets
  end
end
