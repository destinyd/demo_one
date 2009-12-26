# To change this template, choose Tools | Templates
# and open the template in the editor.

class PickGame
  @@pick_per_minute = 1
  @@total_part = 100
  @@least_minutes = 5
  @@per_minute  = 1.minute
  @@over_level = 5
  @@range = [0.1,0.01,0.001,0.0001,0.00001,0.000001]
  @@level_coefficient = 20
  @@range_for_new = 0.01

  def initialize(pick)
    raise "pick cannot be empty" if pick.blank?
    @pick = pick
    @player_id = pick.player_id
  end

  def result
    @result ||=
      more_than_least_minutes? ? pick : nil #lack_time_result
  end

  def level_up
    @pick.level += 1
    @pick.save
  end

  def level_up_money  # 升级所需
    10 ** ( 1 + 2 * @pick.level)
  end

  def mtype
    @mtype ||=
      case @pick.ctype
    when 0 then Ore
    when 1 then Wood
    when 2 then Leather
    else raise "no this material type"
    end
  end

  def change_pick_type(to_type)
    @to_type  = to_type.to_i
    if MATERIAL_TYPES_TO_IDS.has_value?(@to_type)
      @pick.ctype = @to_type
      @pick.save!
    else
      raise "wrong pick type"
    end
  end

  private
  def pick
    @pick_result = {}
    total_parts.times do
      level = real_level
      m = new_material? ? create_material(level) :  rand_material(level)
      @pick_result[m] ?
        @pick_result[m] += real_amount : @pick_result[m] = real_amount
    end
    #    save_time#记录时间 注释掉意味着不限制
    player_get_material(@pick_result) unless @pick_result.blank?
    @pick_result
  end

  def real_level
    level = @pick.level + rand_level
    level=1 if level < 1
    level
  end

  def save_time
    @pick.picked_at = Time.now
    @pick.save
  end

  def player_get_material(materials_to_amount)
    Player.find(@player_id).get_items(materials_to_amount)
  end

  def rand_material(level)
    m = mtype.get_by_level(level)
    m ? m : create_material(level)
  end

  def create_material(level)
		count = @@level_coefficient * level * level
		energy  = rand(count-2) + 1 # energy
		stable  = count - energy #  stable
		mtype.create_by_pick(level,@player_id,{:energy => energy, :stable => stable})
  end

  def new_material?
    rand < @@range_for_new
  end

  def real_amount
    num = number_of_each
    if overage > 0
      num += 1
      @overage -=  1
    end
    num
  end

  def rand_level
	  randnum = rand
	  @@over_level.times do |t|
      return @@over_level - t if @@range[@@over_level - t] > randnum
	  end
    return -1
	end

  def total_parts
    @total_parts ||= total_minutes > @@total_part ? @@total_part : total_minutes
  end

  def overage
    @overage ||= total_minutes - total_minutes / total_parts * total_parts
  end

  def number_of_each
    @number_of_each ||= total_minutes / total_parts
  end

  def lack_time_result
    "最低收获时间为#{@@least_minutes}分钟，请稍后再试"
  end
  def more_than_least_minutes?
    total_minutes >= @@least_minutes
  end
  
  def total_minutes
    @total_minutes ||= ((now_time - @pick.picked_at)/@@per_minute).to_i
  end

  def now_time
    @now_time ||= Time.now
  end
end
