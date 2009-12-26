class Wait < ActiveRecord::Base
  validates_uniqueness_of :adventurer_id

  def self.partys
    ids = Wait.find(:all,:conditions => {:scene_id => 3},:select => "id,adventurer_id").map(&:adventurer_id)
    ids.blank? ? ids : Party.find(ids)
  end

  def self.party_wait(ad,scene_id)
    Wait.create(
      :job => ad.job,
      :adventurer_id => ad.party.id,
      :scene_id => scene_id
    ) if ! (p=Wait.find(:first, :conditions => { :adventurer_id => ad.party.id,:scene_id => scene_id})) || Party.find(p.adventurer_id).adventurers.length < 5
  end

  #  def self.party_stop_wait(id)
  def self.party_stop_wait(ad,scene_id)
    Wait.find(:first,:conditions => {
        :adventurer_id => ad.party.id,
        :scene_id => scene_id
      }
    ).destroy
    #    Wait.find(id).destroy
  end

  def self.other_or_wait(adventurer_id,scene_id)
    adventurer=Adventurer.find(adventurer_id)
    wait=Wait.find(:first,:conditions =>
        ["adventurer_id != ? and scene_id = ? and job = ?",adventurer_id,scene_id,adventurer.job]
    )

    return wait.destroy.adventurer_id if wait

    wait=Wait.find(:first,:conditions => {
        :adventurer_id => adventurer_id,
        :scene_id => scene_id,
        :job => adventurer.job
      })
    Wait.create(
      :adventurer_id => adventurer_id,
      :scene_id => scene_id,
      :job => adventurer.job
    ) unless wait
    nil
  end

  def self.destroy_by_adventurer_id(adventurer_id)
    begin
      find_by_adventurer_id(adventurer_id).destroy
    rescue
    end
  end
end
