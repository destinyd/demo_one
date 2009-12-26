class PlayerItemsController < ApplicationController
	before_filter :with_user
  before_filter :with_player
  before_filter :with_player_item, :only => :destroy
  before_filter :with_title

  def index
    @subtitle="我的材料"
    @player_items = @player.player_items.with_item
  end

  def destroy
    @player_item.transaction do
      @total_money = @player_item.sell(params[:amount])
      @player.get_money @total_money unless @total_money.blank?
    end
    index_by_flash "你获得了#{@total_money}金币"
  end


	
	private
  def with_title
    @title="仓库世界"
  end

end
