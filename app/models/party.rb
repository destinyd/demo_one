class Party < ActiveRecord::Base
  has_many :adventurers
  belongs_to :teamleader,:class_name => "Adventurer",:foreign_key => :adventurer_id

  before_destroy :empty_party_id

  def empty_party_id
    adventurers.each do |ad|
      ad.party_id = nil
      ad.save
    end
  end
end
