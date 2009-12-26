class IdentifiesController < ApplicationController
  before_filter :with_user
  before_filter :with_player
  before_filter :with_player_item
  
  #  def index
  #    if params[:item].blank?
  #      redirect_to '/players'
  #      return
  #    end
  #
  #    if not ["equip","item","material"].include?(params[:item][:item_type])
  #      flash[:notice]="想怎样啊小样"
  #      redirect_to :controller => :players
  #      return
  #    end
  #
  #    ownitem=('Player' + params[:item][:item_type].downcase).constantize.find(
  #      :first ,:conditions => {
  #        :player_id => current_player.id,
  #        params[:item][:item_type].downcase + "_id" => params[:item][:item_id]
  #      })
  #
  #    if(ownitem)
  #      @item=params[:item][:item_type].capitalize.constantize.find(params[:item][:item_id])
  #      @level=@item.level
  #      #      respond_to do |format|
  #      case params[:item][:item_type]
  #      when "equip"
  #        @cost = 1000 ** @level
  #      when "item"
  #        @cost = 100 ** @level
  #      when "material"
  #        @cost = 10 ** @level
  #      end
  #      #format.html { render :template => Params[:item][:item_type] }
  #      #      end
  #    else
  #      flash[:notice]="你不拥有此东西"
  #      redirect_to :controller => :players
  #      return
  #    end
  #  end

  def show
    @cost  = @player_item.identify_cost
    @item = @player_item.item
  end

  def update
    if @player.cost_money(@player_item.identify_cost)
      @player_item.identify
      redirect_to item_path(@player_item.item)
    else
      flash[:notice] = "你没有那么多钱"
      redirect_to identify_path(@player_item)
    end

  end
  
  private
  def with_title
    @title="鉴定"
  end

end
