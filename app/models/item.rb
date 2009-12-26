class Item < ActiveRecord::Base
  acts_as_nameable
  belongs_to :player
  validates_presence_of     :property,:level,:player_id

  attr_accessible :name , :on => :update
  attr_accessible :property, :plus, :player_id, :level, :system_named , :on => :update

  has_many :player_items,:dependent => :destroy
  has_many :players, :through => :player_items

  @@base_percent = 1
  @@percent_per_level = 0.2

  named_scope :materials,:conditions => {:type => ::MATERIAL_TYPES}
  named_scope :equips,:conditions => {:type => ::EQUIP_TYPES}

  def amount
    self[:amount].to_i
  end

  def self.make_item(player_id,level, base,properties = {},pluses = {})
    base = base  * (@@base_percent + (level-1) * @@percent_per_level)
    base = base.to_i
    properties[:base] = base
    hash = {:level => level, :property => get_property(properties), :plus => get_property(pluses), :player_id => player_id}
    item = first :conditions => hash
    item.blank? ? create(hash.merge({:system_named => init_name})) : item
  end

  def property_detail
    return @properties unless @properties.blank?
    @properties = properties
  end

  def plus_detail
    return @pluses unless @pluses.blank?
    @pluses = self.plus.blank? ? {} : pluses 
  end

  def is?
    @type = self.class.to_s
    if ::MATERIAL_TYPES.include? @type
      return "Material"
    elsif ::EQUIP_TYPES.include? @type
      return "Equip"
    else
      raise "nothing is #{@type}"
    end
  end

  def self.get(level,properties,pluses)
    first :conditions => {
      :level => level,
      :property => Item.get_property(properties),
      :plus => pluses ? Item.get_property(pluses) : nil
    }
  end

  def self.get_property(properties)
    p = ""
    properties.each do |k,v|
      p += ";" unless p.blank?
      p +=  "#{k}:#{v}"
    end
    p
  end

  def properties
    return @properties unless @properties.blank?
    @properties = {}
    properties_array = self.property.split(";")
    properties_array.each do |p|
      tmp_property = p.split(":")
      @properties[tmp_property[0].to_sym]  = tmp_property[1].to_i
    end
    @properties
  end

  def pluses
    return @pluses unless @pluses.blank?
    @pluses = {}
    pluses_array = self.plus.split(";")
    pluses_array.each do |p|
      tmp_property = p.split(":")
      @properties[tmp_property[0].to_sym]  = tmp_property[1].to_i
    end
    @pluses
  end

  protected
  def self.init_name
    "#{self.human_name}#{self.time_string}"
  end

  def self.time_string
    Time.now.strftime("%Y%m%d%H%M%S") + sprintf("%04d",rand(10000))
  end
  
  def properties_to_property
    @property = ""
    @properties.each do |k,v|
      @property += ";" unless @property.blank?
      @property += "#{k}:#{v}"
    end
    @properties = nil
  end

  #  class Equip < ActiveRecord::Base
  #  #ctype 0=>"sword's sword"  1=>"sword's armor"
  #  acts_as_nameable
  #  has_many :auctions, :as => :item
  #  has_many :player, :through => :playerequips
  #
  #  validates_presence_of     :par,:level,:player_id,:ctype
  ##  attr_accessible :name,:on => :update
  ##  validates_length_of :name, :within => 2..30
  ##  validates_uniqueness_of :name
  #
  #  @etype={"剑" => 0,"衣" => 1}
  #  @ietype={ 0 => "剑",1 => "衣"}
  #  @maketype={ 0 => [0,1], 1 => [2] }
  #
  #
  #  def self.create_by_pid_par_level_ctype(pid,par,level,ctype)
  #    tmp=self.new
  #    tmp.player_id=pid
  #    tmp.par=par
  #    tmp.level=level
  #    tmp.ctype=ctype
  #    tmp.system_named=@ietype[ctype]+Time.now.strftime("%Y%m%d%H%M%S")+sprintf("%04d",rand(10000))
  #    tmp.save
  #    tmp
  #  end
  #  def self.etype
  #    @etype
  #  end
  #  def self.ietype
  #    @ietype
  #  end
  #  def self.maketype
  #    @maketype
  #  end
  #end



  #class Material < ActiveRecord::Base
  #  #ctype 0=>"kuang" 1=>"mutou"
  #
  #  @mtype={"矿石" => 0,"木头" => 1,"皮革" => 2}# ,"药草" => 3,"食材" => 4,"宝石" => 5}
  #  @imtype={0 => "矿石",1 => "木头",2 => "皮革"}
  #
  #  has_many :playermaterials,:dependent => :destroy
  #  has_many :players, :through => :playermaterials
  #
  #  has_many :items, :as => :item
  #
  #  acts_as_nameable
  #  validates_uniqueness_of :ctype,:scope => [:level, :par1,:par2]
  #
  #	def self.createByLevel(level,ctype,p_id,par1,par2)
  #		b=self.findByLCP(level,ctype,par1,par2)
  #    return b if b
  #		a=self.new
  #		a.system_named=@imtype[ctype]+Time.now.strftime("%Y%m%d%H%M%S")+sprintf("%04d",rand(99))
  #		a.level=level
  #		a.ctype=ctype
  #		a.created_at=Time.now
  #		a.par1=par1
  #		a.par2=par2
  #		a.player_id=p_id
  #		a.save
  #		a
  #	end
  #	def self.findByLevelCtype(level,ctype)
  #		return find(:first,:conditions => {:level=>level,:ctype=>ctype},:order => 'rand()')
  #	end
  #
  #	def	self.findByLCP(level,ctype,par1,par2)
  #		return find(:first,:conditions => {:level=>level,:ctype=>ctype,:par1=>par1,:par2=>par2})
  #	end
  #
  #  def self.mtype
  #    @mtype
  #  end
  #  def self.imtype
  #    @imtype
  #  end
  #
  #
  #
  #end


end
