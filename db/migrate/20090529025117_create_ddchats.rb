class CreateDdchats < ActiveRecord::Migration
  def self.up
    create_table :ddchats do |t|
      t.string :name,:null => false
      t.string :body,:null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :ddchats
  end
end
