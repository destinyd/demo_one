class AddPartyIdToAdventurer < ActiveRecord::Migration
  def self.up
    add_column :adventurers,:party_id,:integer
    add_index :adventurers,:party_id
  end

  def self.down
    remove_index :adventurers,:party_id
    remove_column :adventurers,:party_id
  end
end
