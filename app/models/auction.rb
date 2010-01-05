class Auction < ActiveRecord::Base
  belongs_to :item, :polymorphic => true
  belongs_to :player

  attr_accessible :item_id,:item_type,:num,:money,:sellday

  def self.clear_timeout
    auctions=all(:conditions => ["finish_at <= ?",Time.now],:lock => true)
    auctions.each do |auction|
      if auction.highest_id
        auction.highest.get_item(auction.item_id, auction.item_type, auction.num)
        auction.highest.do_now(
          "你花了#{auction.money}个金币成功拍下了#{auction.num}个#{auction.item.name}"
        )
        days= auction.finish_at - auction.created_at
        money=  ((1.0 - days/100) * auction.money).to_i
        auction.player.get_money(money)
        auction.player.do_now("你拍卖的#{auction.num}个#{auction.item.name}获得了#{money}个金币")
        auction.destroy
        #卖价得钱
      else
        auction.player.get_item(auction.item_id, auction.item_type, auction.num)
        auction.destroy
      end
    end
  end

  def min(player_id)
    player=Player.find(player_id,:lock => true)
    add=self.money / 100
    add= (add < 100) ? 100 : add
    money = self.money+add
    if player.cost_money(money)
      self.highest_id = player_id
      self.money = money
      self.save!
    else
      nil
    end

  end

  def highest
    Player.find(self.highest_id) if self.highest_id
  end

  def auction(player_id,sellday)
    return nil if sellday.nil? ||
      player_id.nil? ||  self.num.nil? || self.money.nil? ||
      self.item_id.nil? || self.item_type.nil?
    return nil unless self.item_type == "item" || self.item_type == "equip" ||
      self.item_type == "material"
    player=Player.find(player_id,:lock => true)
    return nil if sellday>30 || sellday<1 ||
      self.num<1 || self.money<1
    costmoney = (sellday * self.money / 10.0).to_i
    costmoney = costmoney < 0 ? 0 : costmoney
    return nil if player.money < costmoney
    playeritem=player.has_item_with_nolock(self.item_id, self.item_type, self.num)
    return nil if playeritem.nil?
    playeritem.num -= self.num
    playeritem.save
    playeritem.destroy if playeritem.num < 1
    player.money -= costmoney
    player.save
    self.item_type = self.item_type.capitalize
    self.finish_at = sellday.days.from_now
    self.player_id = player_id
    self.save!
  end


  def getsellthing(player_id)
    ownitem=('Player' + self.item_type).constantize.find(:first ,:conditions => {
        :islock => 0,
        :player_id => player_id,
        self.item_type + "_id" => self.item_id
      },
      :lock => true)
    if ownitem
      ownitem.num+= self.num
      ownitem.save
    else
      ('Player' + self.item_type).constantize.create(
        :islock => 0,
        :player_id => player_id,
        self.item_type + "_id" => self.item_id,
        :num => self.num
      )
    end
    return self.destroy
  end
end
