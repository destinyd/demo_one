class PlayerItem < ActiveRecord::Base
  belongs_to :player
  belongs_to :item

  validates_presence_of :player_id
  validates_presence_of :item_id
  validates_presence_of :amount
	validates_uniqueness_of :item_id, :scope => [:player_id, :item_id,:lock]

  named_scope :with_item, :include => :item

  def sell(amount)
    amount  = amount.to_i
    raise "wrong amount" if amount <= 0
    @total_money = amount * self.item.level
    if self.amount < amount
      raise "you don't have so many this item"
    elsif self.amount == amount
      self.destroy
    else
      self.amount -= amount
      self.save
    end
    @total_money
  end

  def identify_cost
    case self.item.is?
    when "Equip"
      @cost = 100 ** self.item.level
    when "Material"
      @cost = 10 ** self.item.level
    end
    @cost
  end

  def identify
    self.known  = true
    self.save
  end

  #  class Playerequip < ActiveRecord::Base
  #  belongs_to :player
  #  belongs_to :equip
  #
  #  def put_on
  #    if self.num<=1
  #      self.destroy
  #    else
  #      self.num=self.num-1
  #      self.save
  #    end
  #  end
  #
  #  def self.find_lock_equip(player_id,equip_id)
  #    find(:first,:conditions => {:player_id => player_id,:equip_id => equip_id,
  #        :islock => 1})
  #  end
  #
  #  def self.take_off_equip(player_id,equip_id)
  #    pe=find_lock_equip player_id,equip_id
  #    if pe
  #      pe.num+=1
  #      pe.save
  #    else
  #      create(:player_id => player_id,:equip_id => equip_id,:islock => true,:num => 1)
  #    end
  #  end
  #
  #end
  #class Playermaterial < ActiveRecord::Base
  #  belongs_to :player
  #  belongs_to :material
  #
  #	validates_uniqueness_of :id, :scope => [:player_id,:material_id,:islock]
  #
  #  def self.createbyarray(materarray,player_id)
  #    materarray.each do |mater|
  #      createbyone(mater,player_id)
  #    end
  #  end
  #  def self.createbyone(mater,player_id)
  #    tmp=findours(mater[0],player_id)
  #    if tmp
  #      tmp.num+=mater[2]
  #      tmp.save
  #    else
  #      create(:material_id => mater[0],:num => mater[2],:player_id => player_id)
  #    end
  #  end
  #  def self.findours(mater,player_id)
  #    find(:first,:conditions=>["player_id = ? and material_id = ?",player_id,mater])
  #  end
  #
  #  def self.get_materials(player_id,mater_id,num)
  #    m=first(:conditions => {:player_id => player_id,:material_id => mater_id,:islock => false})
  #    if m
  #      m.num+=num
  #    else
  #      create(:player_id => player_id,:material_id => mater_id,:islock => false,:num => num)
  #    end
  #  end
  #
  #  def has?(num)
  #    self.num >= num
  #  end
  #
  #  def cost(num)
  #    if self.has?(num)
  #      self.num-=num
  #      return self.destroy if self.num<=0
  #      self.save!
  #    end
  #  end
  #
  #end

end
