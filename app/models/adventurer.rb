class Adventurer < ActiveRecord::Base
  belongs_to :player

  has_many :fighters ,:order => "id asc"
  has_many :skills   ,:through => :adventurer_skills
  has_many :adventurer_skills,  :dependent => :destroy

  belongs_to :party
  has_one :teamleader
  ##  has_many :sword_swords,:through => :sword_to_skills
  #  has_many :sword_to_skills,:dependent => :destroy
  def name
    self.player.name
  end

  def self.kill(adventurer_id)
    update_counters adventurer_id,:mhp => 1,:hp => 1,:kill => 1
  end

  def self.win(adventurer_id)
    update_counters adventurer_id,:mhp => 1,:hp => 1,:win => 1
  end

  def self.lose(adventurer_id)
    update_counters adventurer_id,:lose => 1
  end

end
