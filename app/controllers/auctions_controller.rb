class AuctionsController < ApplicationController
  before_filter :with_user
  before_filter :title


  def index
    Auction.clear_timeout
    @Auctions=Auction.paginate(:all,
      #:conditions => ["player_id!=?",session[:player_id]],
      :page => params[:page],
      :per_page => 20
    )
    @subtitle="拍卖行"
  end

  def new
    @subtitle="拍卖"
    @auction=Auction.new
  end

  def create
    @auction=Auction.new(params[:auction])
     if @auction.auction(session[:player_id],params[:sellday].to_i)
       flash[:notice]="拍卖成功"
     else
       flash[:notice]="拍卖失败"
     end
     redirect_to :action => :index
  end

  def min
    begin
      @auction=Auction.find(params[:id],:lock => true)
    rescue
      index_by_flash("竞拍已经结束")
      return
    end
    if @auction.player_id == session[:player_id]
      index_by_flash( "不能竞拍自己拍卖的商品")
      return
    end
    if @auction.highest_id == session[:player_id]
      index_by_flash( "你已经是竞价最高者")
      return
    end

    if @auction.min session[:player_id]
      index_by_flash("竞价成功")
    else
      index_by_flash("你可没那么多钱哦！")
    end

  end

  private
    def title
      @title = "商业世界"
    end

end
