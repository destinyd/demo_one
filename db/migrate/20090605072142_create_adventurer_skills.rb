class CreateAdventurerSkills < ActiveRecord::Migration
  def self.up
    create_table :adventurer_skills do |t|
      t.integer :adventurer_id
      t.integer :skill_id

      t.timestamps
    end
    add_index :adventurer_skills, :adventurer_id
    add_index :adventurer_skills, :skill_id
  end

  def self.down
    drop_table :adventurer_skills
  end
end
