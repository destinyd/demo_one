class CreateEffects < ActiveRecord::Migration
  def self.up
    create_table :effects do |t|
      t.boolean :target # 指向？
      t.boolean :enemy # 敌方 己方 全部
      t.integer :duration #持续时间
      t.integer :number #人数
      t.string :prototype # 技能原型
      t.integer :limit #叠加层数
      t.integer :cooldown #冷却时间
      t.integer :player_id #发现者ID

      t.timestamps
    end
  end

  def self.down
    drop_table :effects
  end
end
