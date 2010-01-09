class Player < ActiveRecord::Base
  before_create do |p|
    p.money = 10000000
  end

  acts_as_fleximage :image_directory => 'data/images/players/'
  missing_image_message  '图片丢失'
  invalid_image_message '图片选取有误'
  default_image_path 'public/images/nologo.jpg'
  image_storage_format :jpg
  output_image_jpg_quality 85
  preprocess_image do |image|
    image.resize '240x240'
  end
  require_image            false 
  acts_as_nameable
  belongs_to :user
  has_one :pick
  has_one :adventurer

  has_many :pluginmags,:dependent => :destroy
  has_many :plugins, :through => :pluginmags,:include => :plugins

  has_many :player_pets,:dependent => :destroy,:include => :pet
  has_many :pets, :through => :player_pets
  has_many :shops # 销售
  has_many :statuses
  has_many :mails,:foreign_key  => :to_id

  #Equip Material to Item
  has_many :player_items,:dependent => :destroy
  
  @select = "items.*,player_items.amount,player_items.lock,player_items.known,player_items.id as player_item_id"
  has_many :items, :through => :player_items,:select => @select ,:order => "type asc"
  has_many :materials, :through => :player_items, :conditions => {:type => ::MATERIAL_TYPES},:source => :item,:select => @select,:order => "type asc"

  has_many :lock_player_items, :class_name => "PlayerItem", :conditions => {:lock => true}, :dependent => :destroy
  has_many :lock_items, :class_name => "Item", :through => :unlock_player_items, :source => :item
  has_many :known_player_items, :class_name => "PlayerItem", :conditions => {:known => true}, :dependent => :destroy
  has_many :known_items, :class_name => "Item", :through => :known_player_items, :source => :item

  has_many :player_effects
  has_many :effect, :through => :player_effects

  has_many :player_signs, :class_name => "PlayerEffect",:conditions => "player_effects.scene_id is NULL and player_effects.scene_type is NULL and player_effects.finish is NULL", :select => "player_effects.player_id,player_effects.effect_id,player_effects.finish,player_effects.finish_time,player_effects.id"

  has_many :signs, :through => :player_signs, :class_name => "Sign",:source => :effect, :select => "effects.prototype", :foreign_key => :effect_id

  attr_accessible :name,:user_id,:image_file, :on => :create
  validates_presence_of :name

  attr_accessible  :signed,:image_file, :on => :update


  include SignEngine

  def buy_shop(shop,num)
    raise "wrong shop" if shop.blank?
    num = num.to_i
    raise "player_#{self.id} buy shop_#{shop.id} with a wrong number" if num < 1
    total = shop.price * num
    if self.cost_money total
      shop.player.get_money total
      shop.num -= num
      shop.save
      self.get_item shop.item, num
      total
    end
  end

  def start_shop_sell(params)
    @item = self.player_items.find(params[:player_item_id]).item
    @num = params[:num]
    shops.create(params) if cost_item(@item,@num)
  end

  def count_new_mail
    Mail.count(:conditions => {:to_id => self.id,:isread  => false})
  end

  def is_self?(player)
    self == player
  end

  def do_now(status)
    self.statuses.create(:status => status) unless status.blank?
  end

  def player_item_by_item(item)
    PlayerItem.first :conditions => {:player_id => self.id, :item_id => item.id }
  end
  
  def cost_item(item,amount=1)
    amount = amount.to_i
    raise "wrong amount" if amount < 1 
    player_item = player_item_by_item(item)
    player_item.amount -= amount
    if player_item.amount >0 
      player_item.save
    elsif player_item.amount == 0
      player_item.destroy
    elsif player_item.amount < 0
      raise "#{self.name} have no #{amount} #{item.id}##{item.name}"
    end
    true
  end


  def cost_player_items(player_items_to_amounts)
    player_items_to_amounts.each do |player_item,amount|
      player_item.amount -= amount
      player_item.save
    end
  end

  def get_item(item,amount=1)
    raise "item can not be nil" unless item
    raise "amount must larger than 0" if amount < 1
    player_items.transaction do
      @pi = player_items.find_by_item_id_and_lock item, nil
      if @pi
        @pi.amount += amount
        @pi.save
        @pi
      else
        player_items.create(:item_id => item.id, :amount => amount)
      end
    end
  end

  def get_items(items_to_amounts)
    items_to_amounts.each do |item,amount|
      get_item(item,amount)
    end
  end
  
  def has_items?(items_to_amounts)
    items_to_amounts.all? do |item,amount|
      has_item?(item,amount)
    end
  end

  def has_item?(item,amount)
    case item.class.to_s
    when "Fixnum"
      @item = player_items.select{|pi| pi.item_id == item and pi.amount >= amount }
    else
      @item = player_items.select{|pi| pi.item == item and pi.amount >= amount }
    end
    !@item.blank?
  end

  def get_money(money)
    self.money += money
    self.save!
  end

  def cost_money(money)
    if self.money>=money
      self.money-=money
      return self.save!
    end
  end
end
