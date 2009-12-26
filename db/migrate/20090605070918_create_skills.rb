class CreateSkills < ActiveRecord::Migration
  def self.up
    create_table :skills do |t|
      t.integer :job
      t.string :hits
      t.integer :player_id
      t.string :plus

      t.timestamps
    end
    add_index :skills, :player_id
  end

  def self.down
    drop_table :skills
  end
end
