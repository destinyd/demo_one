module GameDiyWar
  module Jobs
    module Enemy
      JOB = :enemy
      JOBID = 10

      def order(*order)
        neworder=order[0].to_i.abs.to_s
        super(neworder)
      end

      def random_action
        @action= (rand(3)+1).to_s
      end

      def get_mul(p,e)
        pa =  p.action.blank?  ?  0 : p.action.to_i
        eb =  e.action.blank?  ?  0 : e.action.to_i
        contrast(pa,eb)
      end

      def get_damage(p,mul)
        if mul == 1
          damage = p.mhp/10
          damage = ((damage < 1) ? 1 :damage)
        elsif mul == 2
          damage = mul * p.mhp/10
          damage = ((damage < 1) ? 1 :damage)
        end
        damage
      end


      def fight(e)
        mul1 = get_mul(self,e)

        if mul1 == 2
          damage = get_damage(self, mul1)
          e.hp-= damage
          Output.capital(damage, @name,e.name)
          return
        end
        if mul1 == 1
          damage = get_damage(self, mul1)
          e.hp -= damage
          Output.attack(damage, @name,e.name)
        end
      end

      def adventure_fight(enemies)
        enemy       = enemies.select{|e| e.side != @side and e.alive?}
        unless enemy.blank?
          mul         = 1
          damage      = get_damage(self, mul)
          e = enemy[rand(enemy.count)]
          e.hp -=  damage
          Output.attack(damage, @name,e.name)
        end
      end


      def save_special
      end

      def new_round
        @action=""
      end

 
      def contrast(a,b)
        return 0 if a== 0
        return 2 if b== 0
        if a%3==b-1
          return 2
        else
          return 1
        end
      end

      def info
        #      weapon=Equip.find(@weapon_id).name if @weapon_id
        #      armor=Equip.find(@armor_id).name if @armor_id
        @name =  Pet.find(@adventurer_id).name
        @roundover = can_activity?
        {:hp => @hp,:mhp => @mhp,:job => @job,
          :weapon => nil,:armor => nil,:action => @action,
          :side => @side,:over => @over,:name => @name,:adventurer_id => @adventurer_id,
          :roundover => @roundover
        }
      end


    end
  end
end
