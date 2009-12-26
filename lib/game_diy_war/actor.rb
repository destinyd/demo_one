# To change this template, choose Tools | Templates
# and open the template in the editor.

module GameDiyWar
  class Actor
    #    JOBS=[:enemy,:swordman,:mage]
    #    JOBNAME=["怪物","剑客","法师"]
    attr_accessor :fighter_id,:hp,:mhp,:job,:weapon_id,:armor_id,
      :action,:side,:over,:adventurer_id,:plus,
      :output,:name,:roundover

    alias_attribute :id,:fighter_id

    def initialize(fighter)
      @fighter_id = fighter.id
      #      fighter.Fighter.find(fighter_id)
      @hp , @mhp,@job,@weapon_id,@armor_id,@action,@side,@over,@adventurer_id,@plus=
        fighter.hp,fighter.mhp,fighter.job ,fighter.weapon_id,
        fighter.armor_id,fighter.action,fighter.side,fighter.over,
        fighter.adventurer_id,fighter.plus
      @name = fighter.job == 10 ? Pet.find(fighter.adventurer_id).name : fighter.adventurer.name 
      @action="" if @action.nil?
      load_job
    end

    def order(order)
      @action=order if can_activity?
    end

    def load_job
      case GameDiyWar::Constant::jobs[@job]
      when :knight then extend GameDiyWar::Jobs::Knight
      when :swordman then extend GameDiyWar::Jobs::Swordman
      when :mage then extend GameDiyWar::Jobs::Mage
      when :enemy then extend GameDiyWar::Jobs::Enemy
      end
    end

    def save
      fighter = Fighter.find(@fighter_id)
      fighter.hp,fighter.action,fighter.over,fighter.plus= @hp ,@action,@over,@plus
      fighter.save
      save_special
    end


    def can_activity?
      @action.blank? && @hp >0
    end

    def info
      weapon=Equip.find(@weapon_id).name if @weapon_id
      armor=Equip.find(@armor_id).name if @armor_id
      @roundover = can_activity?
      {:hp => @hp,:mhp => @mhp,:job => @job,
        :weapon => weapon,:armor => armor,:action => @action,
        :side => @side,:over => @over,:name => @name,:adventurer_id => @adventurer_id,
        :roundover => @roundover
      }
    end

    def fight_enemy(e)
      damage = get_damage(self, 1)
      e.hp -= damage
      Output.attack(damage, @name,e.name)
    end

    def alive?
      @hp > 0
    end

    def adventurer
      @adventurer ||= Adventurer.find_by_id(@adventurer_id)
    end

    def player
      @player ||=  adventurer.player
    end


  end
end
