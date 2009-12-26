  class ShopsController < ApplicationController
    before_filter :with_user
    before_filter :with_player
    before_filter :title

    # GET /shops
    # GET /shops.xml
    def index
      @subtitle="商店街"
      if params[:player_id]
        @shops = Shop.paginate_all_by_player_id params[:player_id], :per_page => 20,:page => params[:page]
      else
        @shops = Shop.paginate :per_page => 20,:page => params[:page]
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @shops }
    end
  end


  # GET /shops/new
  # GET /shops/new.xml
  def new
    @subtitle="摆摊"
    @player_item = @player.player_items.find params[:player_item]
    @shop = Shop.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @shop }
    end
  end

  def create
    if @shop = @player.start_shop_sell(params[:shop])
      flash[:notice] = '你已经成功摆摊.'
      redirect_to :action => :show , :id => @shop
    else
      format.html { render :action => "new" }
    end
  end

  # DELETE /shops/1
  # DELETE /shops/1.xml
  def destroy
    @shop = @player.shops.find(params[:id])
    @shop.destroy

    respond_to do |format|
      format.html { redirect_to(shops_url) }
      format.xml  { head :ok }
    end
  end

  def show
    @shop = Shop.find(params[:id])
  end

  def buy
    @shop = Shop.find(params[:id])
    if @cost = @player.buy(@shop,params[:shop][:num])
      index_by_flash "成功购买#{@shop.item.name} * #{params[:shop][:num]},花费#{@cost}金币"
    else
      flash[:notice] = "你的钱不够"
    end

  end
  private
    def title
      @title = "商业世界"
    end

  #  def need_self
  #    redirect_to players_path unless @album.user.is_self?(@player)
  #  end

end
