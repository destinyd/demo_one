class CreatePluginmags < ActiveRecord::Migration
  def self.up
    create_table :pluginmags do |t|
      t.integer :player_id,:null => false
      t.integer :plugin_id,:null => false
    end
    add_index :pluginmags, :player_id
    add_index :pluginmags, :plugin_id
  end

  def self.down
    drop_table :pluginmags
  end
end
