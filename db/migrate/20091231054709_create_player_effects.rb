class CreatePlayerEffects < ActiveRecord::Migration
  def self.up
    create_table :player_effects do |t|
      t.datetime :at
      t.datetime :finish_time
      t.boolean :finish
      t.integer :round
      t.integer :player_id
      t.integer :effect_id
      t.integer :scene_id
      t.string :scene_type

      t.timestamps
    end
    add_index :player_effects, :player_id
    add_index :player_effects, :effect_id
    add_index :player_effects, [:scene_id, :scene_type]
  end

  def self.down
    drop_table :player_effects
  end
end
