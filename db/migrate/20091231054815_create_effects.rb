class CreateEffects < ActiveRecord::Migration
  def self.up
    create_table :effects do |t|
      t.boolean :target
      t.boolean :enemy
      t.integer :duration
      t.integer :number
      t.string :prototype
      t.integer :limit
      t.integer :cooldown
      t.integer :player_id

      t.timestamps
    end
  end

  def self.down
    drop_table :effects
  end
end
