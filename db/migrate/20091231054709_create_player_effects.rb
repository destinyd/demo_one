class CreatePlayerEffects < ActiveRecord::Migration
  def self.up
    create_table :player_effects do |t|
      t.datetime :at #当前状态改变在
      t.datetime :finish_time#结束时间 标志
      t.boolean :finish# 是否结束
      t.integer :round # 回合 在第几回合
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
