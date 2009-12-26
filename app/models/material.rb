class Material < Item
  def self.get_by_level(level)
    find_by_level level,:order => "rand()"
  end

  def self.create_by_pick( level , player_id , properties , pluses = nil)
    @item = get level,properties,pluses
    unless @item
      @item = create :level => level,
        :player_id => player_id,
        :property => Item.get_property(properties),
        :plus => pluses ? Item.get_property(pluses) : "" ,
        :system_named => self.init_name
    end
    @item
  end

  protected


  #@mtype={"矿石" => 0,"木头" => 1,"皮革" => 2}# ,"药草" => 3,"食材" => 4,"宝石" => 5}
#  @imtype={0 => "矿石",1 => "木头",2 => "皮革"}
  def self.mtype
    return @mtype unless @mtype.blank?
    index = 0
    @mtype  = {}
    @@material_types.each do |mt|
      @mtype[mt]  = index
      index += 1
    end
    @mtype
  end

  def self.imtype
    @imtype ||= @mtype.invert
  end
end
