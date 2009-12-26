class PlayerPet < ActiveRecord::Base
  belongs_to :player
  belongs_to :pet

  validates_presence_of     :hp,:happy,:food,:pet_id,:player_id

  #  @grow_up_round = 6.hours
  #  @cost_per_grow_up_round = 0.36 #6*%6
  def race
    pet.class
  end

  def race_name
    pet.class.human_name
  end

  def name
    pet.name
  end

  def basehp
    pet.hp
  end


#  def wait_pray
#    return unless self.needs.blank? || self.ispray
#    ids = Material.all(:limit => 5,:order => "rand()",:select => "id",:conditions => ["type != ?", ::MATERIAL_TYPES[self.pet.ctype]]).map(&:id)
#    self.needs=ids.join(",")
#    return ids if self.save!
#  end
#
#  def pray
#    return if self.needs.blank? || self.ispray
#    p=Player.find(self.player.id,:lock => true)
#    ids=self.needs.split(",")
##    materials=p.has_materials(ids)
#    if materials
#      materials.each{|m| m.cost(1)} #   HERE
#      self.player.do_now("你成功的为'#{self.pet.name}'祈祷，他的属性翻倍了！")
#      self.hp *= 2
#      self.happy *= 2
#      self.food *= 2
#      self.ispray = true
#      return self.save!
#    end
#  end
#
#  def output
#    if self.ispray == false && self.needs.blank?
#      self.grow_up
#      tmp="由于长时间没给'#{self.pet.name}'喂食，所以他饿死啦！"  if self.food < 1
##      tmp="由于你对'#{self.pet.name}'没有爱，所以他逃跑啦！"  if self.happy < 1
#      if tmp
#        self.runout(tmp)
#        return tmp
#      end
##    end
#    if Time.now >= self.created_at + (self.feeddays + 1).days
#      tmp="由于你对'#{self.pet.name}'漠不关心，所以他于深夜潜逃啦！"
#      self.runout(tmp)
##      return tmp
#    end
##    if self.ispray
#      lessminutes = (self.created_at + (self.feeddays + 1).days - Time.now)/ 1.minutes
#      return "离对#{self.pet.name}指令选择结束时间还剩下#{lessminutes.round}分钟"
#    end
#    if self.needs
##      lessminutes = (self.created_at + (self.feeddays + 1).days - Time.now)/ 1.minutes
#      return "#{self.pet.name}的祈祷剩余时间还剩下#{lessminutes.round}分钟"
#    end
#    if (Time.now >= self.created_at + self.feeddays.days) && self.needs.blank?
#      ids=wait_pray
#      materials=Material.find(ids).map(&:name).join(",")
##      return "#{self.pet.name}已经成年，可以收集#{materials}各一个来为宠物祈祷，提升hp或材料转换品质"
#    end
#    return "#{self.pet.name}的状态十分危险，请您好好照顾他" if (self.happy/self.hp.to_f <= 0.2) || (self.food/self.hp.to_f <= 0.2)
#    lessminutes = (self.created_at + self.feeddays.days - Time.now)/ 1.minutes
#    "离饲养结束时间还有#{lessminutes.round}分钟"
#  end
#
##  def is_feed_over?
#    Time.now >= self.created_at + self.feeddays.days
 # end
#
#   def pray_materials_name
#    Material.find(self.needs.split(",")).map(&:name).join(",")
#  end
#
#  def is_self?(player_id)
#    self.player_id == player_id
#  end

#  def kill
#    level=1
#    level+=1  if (self.happy/self.hp) > 0.95
#    level+=1  if self.ispray
#    
#    p=self.player
##    a=Material.findByLevelCtype(level,self.pet.ctype)
#    if a.blank?
#      count=level*level * 20 #$levelXishu*
#      par1=rand(count-2)+1
#      par2=count-par1
#      a= Material.createByLevel(level,self.pet.ctype,p.id,par1,par2)
#    end
##    return a
#  end
#
#
#  def self.mix(pets,player_id)
#    pets=find(pets)
#    return nil if pets.blank?
#    return nil if pets.length < 2
#    hp=0
##    ctype=[]
#    pets.each do |p|
#      return nil unless p.is_self?(player_id)
#      hp+=p.hp
#      ctype.push(p.pet.ctype)
#      p.destroy
#    end
#    hp/=pets.length
#    ctype=ctype.rand
#    pet = Pet.find_pets(hp,ctype)
##    if pet.blank?
#      name="宠物" + Time.now.strftime("%Y%m%d%H%M%S")+sprintf("%02d",rand(100))
#      pet = Pet.new(:hp => hp,:ctype => ctype,:player_id => player_id)
#      pet.system_named = name
#      pet.save
#    end
#    Player.find(player_id).adopt(pet.id,1) # 1为领养天数
#  end
#
##  def runout(status)
#    #self.player.do_now("你的'#{self.pet.name}'因为受不了你惨无人道的虐待而逃跑了！")
#    self.player.do_now(status)
#    self.destroy
#    nil
#  end
#
end
