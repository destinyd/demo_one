# To change this template, choose Tools | Templates
class MakeGame
  @@limit_total = 50
  @@new_to_forms = {"Sword" => ["Ore","Wood"], "Clothes" => ["Leather"]}
  @@forms_to_new = @@new_to_forms.invert
  @@max_level = 5
  

  def initialize(player)
    raise "player must be not nil" unless player
    @player = player
  end

  def make(player_item_ids, amounts)
    get_and_valid_player_items(player_item_ids, amounts)
    cost_items
    if success?
      get_item(make_new_item)
    end
  end

  
  private
  def get_and_valid_player_items(player_item_ids, amounts)
    @player_item_ids = player_item_ids
    @amounts = amounts.map(&:to_i)
    player_items(@player_item_ids)
    player_items_to_amounts(player_item_ids,amounts)
    valid?
  end

  def cost_items
    @player.cost_player_items(@player_items_to_amounts)
  end

  def make_new_item
    level = make_level(properties[:energy],properties[:stable])
    new_item_type.make_item @player.id, level , properties[:energy]
  end

  def make_level(base,stable)
    level = stable / base
    level = 1 if level < 1
    level = @@max_level if level > @@max_level
    level = 1 + rand(level)
  end

  def get_item(item)
   @player.get_item item
  end

  def success?
    @success ||= rand <=  properties[:stable] / properties[:energy].to_f - items_total * 0.01
  end

  def properties
    return @properties unless @properties.blank?
    @properties = property_total #{}
#    @properties[:energy] = property_total(:energy)
#    @properties[:stable] = property_total(:stable)
  end

  def pluses
    return @pluses unless @pluses.blank?
    @pluses = {}
  end
 
  def property_total#(property = :energy)
    properties = {}
    @player_items_to_amounts.each do |player_item,amount|
      player_item.item.properties.each do |k,v|
        if properties[k].blank?
          properties[k] = v.to_i * amount
        else
          properties[k] += v.to_i * amount
        end
      end
    end
    properties
#    properties_hash.each_keys do |k|
#       properties[k] = properties_hash[k].to_i
#     end 
#    end
#    p_str =  "@property_#{property}"
#    return instance_eval(p_str) if instance_eval(p_str)
#    instance_variable_set p_str , @player_items.sum{|player_item| player_item.item.properties[property].to_i }
  end

  def valid?
    same_count
    less_than_limit
    has_items
  end

  def same_count
    raise "count of params is not same" unless @player_item_ids.length == @player_items.length and @player_item_ids.length == @amounts.length
  end

  def player_items(player_item_ids)
    @player_items ||= @player.player_items.with_item.find(player_item_ids)  
  end

  def rand_new_item_type
#    new_item_type = @@new_item_type.map{|k,v| k}
 #   new_item_type[rand(new_item_type.length)]
    @@new_item_type.keys.rand
  end

  def new_item_type
    return @new_item_type if @new_item_type
    @new_item_type = to_type(item_types).constantize
    @new_item_type = rand_new_item_type.constantize unless @new_item_type
    @new_item_type
  end

  def to_type(item_types)
    @to_type = {}
    @@forms_to_new.each{|k,v| @to_type[k]=v if item_types.any?{|item_type| k.include? item_type} }
    index = 0
    if @to_type.length >= 1
#    if @to_type.length == 1
#      @to_type.each{|k,v| return v}
#    elsif @to_type.length > 1
      #rand_num = rand(@to_type.count)
      #@to_type.each{|k,v| return v if index == rand_num; index += 1}
      @to_type.values.rand
    else
      #rand_num = rand(@@forms_to_new.length)
      #@@forms_to_new.each{|k,v| return v if index == rand_num; index += 1}
      @@forms_to_new.values.rand
    end
  end

  def item_types
    @item_types ||= @player_items.map{|player_item| player_item.item.class.to_s}.uniq
  end

  def has_items
    @player_items_to_amounts.all?{|player_item,amount|  player_item.amount >= amount} 
  end

  def player_items_to_amounts(player_items,amounts)
    return @player_items_to_amounts if @player_items_to_amounts
    @player_items_to_amounts = {}
    player_items.each_with_index do |player_item,index|
      player_item = @player_items.select{|pi| pi.id == player_item.to_i}[0]
      @player_items_to_amounts[player_item] = amounts[index].to_i
    end
    @player_items_to_amounts
  end

  def less_than_limit
    raise "too many items" if items_total> @@limit_total
  end
  
  def items_total
    @items_total ||= @amounts.sum
  end
end
