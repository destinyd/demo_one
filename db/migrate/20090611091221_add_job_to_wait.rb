class AddJobToWait < ActiveRecord::Migration
  def self.up
    add_column :waits,:job,:integer,:null => false
  end

  def self.down
    remove_column :waits,:job
  end
end
