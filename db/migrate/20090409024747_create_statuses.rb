class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.string :status
      t.integer :player_id
      t.timestamps
    end
    add_index :statuses, :player_id
  end

  def self.down
    drop_table :statuses
  end
end
