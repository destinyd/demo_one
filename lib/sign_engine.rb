module SignEngine
  def sign(prototype)
    run_player_signs
    player_signs.each{|s| return s if s.effect.prototype == prototype }
    nil
  end

  def sign_to(prototype, finish_time=nil)
    @sign = Sign.find_by_prototype prototype
    raise "not #{prototype} sign" if @sign.blank?
    if @old_sign = sign(prototype)
      return if not finish_time.blank? and @old_sign.finish_time >= finish_time
      @now = @old_sign.finish_time
    else
      @now = Time.now
    end
    finish_time = @now + @sign.duration.seconds if finish_time == nil
    if @old_sign
      @old_sign.finish_time = finish_time
      @old_sign.save
    else
      @old_sign = player_effect.create :finish_time => finish_time, :effect_id => @sign.id
    end
    @old_sign
  end

  protected
  def run_player_signs
    player_signs.each do |ps|
      if ps.finish_time < Time.now
        ps.finish = true
        ps.save
        player_signs.delete ps
      end
    end
  end
end
