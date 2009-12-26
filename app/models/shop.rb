class Shop < ActiveRecord::Base
  before_create do |shop| #form just give player_item_id, no item_id so...
    raise 'player_item_id must be not empty' if shop.player_item_id.blank?
    shop.item_id = PlayerItem.find(shop.player_item_id).item_id
    shop.player_item_id = nil
  end
  belongs_to :player
  belongs_to :item

  validates_presence_of :player_id
  validates_presence_of :num
  validates_presence_of :price

  attr_accessible :player_item_id,:player_id, :num, :price, :on => :create
  attr_accessible :price,:num, :on => :update

  attr_accessor :player_item_id

  after_save do |shop|
    shop.destroy if shop.num == 0
  end

  after_destroy do |shop| #:player_get_remaining_item
    if shop.num > 0 and shop.player
      shop.player.get_item(shop.item_id, shop.num) unless @player.blank?
    end
  end
end
