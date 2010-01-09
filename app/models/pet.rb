class Pet < ActiveRecord::Base
  acts_as_nameable
  acts_as_fleximage :image_directory => 'data/images/pets/'
  missing_image_message  '图片丢失'
  invalid_image_message '图片选取有误'
  default_image_path 'public/images/nopic.gif'
  image_storage_format :jpg
  output_image_jpg_quality 85
  preprocess_image do |image|
    image.resize '240x240'
  end
  require_image            false 
  acts_as_nameable
 
  has_many :player_pets,:dependent => :destroy
  has_many :players, :through => :player_pets
  belongs_to :player
  
  attr_accessible :hp, :type, :player_id , :on => :create
  attr_accessible  :name, :on => :update
  @@level_hp = 20 # 常量

  def self.mix(player_id,hp)
    pet = self.hp(hp)
    pet = create(:hp => hp, :player_id => player_id) unless pet
    pet
  end

  def self.hp(hp)
    thp = (hp / @@level_hp ) * @@level_hp
    thp = thp..(thp + @@level_hp - 1)
    find_by_hp thp
  end

end
