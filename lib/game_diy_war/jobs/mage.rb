module GameDiyWar
  module Jobs
    module Mage
      JOB = :mage
      JOBID = 2
      FIGHTPAR = 5

      def order(*order)
        neworder = ""
        0.upto(4){ |i| neworder += order[i].to_i.abs.to_s }
        super(neworder)
      end

      def random_action
        @action = ""
        0.upto(4) do |i|
          @action += (rand(4)+1).to_s
        end
      end



      def fight_self(e)
        e.name+="的分身"
        mul1 = get_mul(self,e)
        mul2 = get_mul(e,self)
        if mul1 > 0
          damage = get_damage(self, mul1) / FIGHTPAR
          e.hp-= damage
          Output.attack(damage, @name,e.name)
          #          return
        end
        if mul2 > 0
          damage = get_damage(e, mul2) / FIGHTPAR
          @hp-= damage
          Output.attack(damage, e.name,@name)
          #          return
        end
      end

      def get_mul(p,e)
        mul=0
        0.upto(4) do |i|
          pa =  p.action[i..i].nil?  ?  0 : p.action[i..i].to_i
          eb =  e.action[i..i].nil?  ?  0 : e.action[i..i].to_i
          mul += contrast(pa,eb)
        end
        mul
      end

      def get_damage(p,mul)
        damage = mul * p.mhp/10
        damage = ((damage < 1) ? 1 :damage)
        damage
      end

      def adventure_fight(enemies)
        enemy       = enemies.select{|e| e.side != @side and e.alive?}
        unless enemy.blank?
          mul         = 1
          damage      = get_damage(self, mul)
          enemy.each do |e|
            e.hp -=  damage
            Output.attack(damage, @name,e.name)
          end
        end
      end


      def fight(e)
        mul1 = get_mul(self,e)
        if mul1 > 0
          damage = get_damage(self, mul1) / FIGHTPAR
          e.hp-= damage
          Output.attack(damage, @name,e.name)
        end
      end

      def save_special
      end

      #
      #      def create
      #        adventurer=Adventurer.find(@adventurer_id)
      #        scene=Scene.create
      #        player=Fighter.create(
      #          :hp => adventurer.hp ,
      #          :mhp => adventurer.mhp,
      #          :job => JOBID,
      #          :weapon_id => adventurer.weapon_id,
      #          :armor_id => adventurer.armor_id,
      #          :scene_id => scene.id,
      #          :adventurer_id => adventurer.id
      #        )
      #        enemy=Fighter.create(
      #          :hp => adventurer.hp ,
      #          :mhp => adventurer.mhp,
      #          :job => JOBID,
      #          :weapon_id => adventurer.weapon_id,
      #          :armor_id => adventurer.armor_id,
      #          :side => 1,
      #          :scene_id => scene.id,
      #          :adventurer_id => adventurer.id
      #        )
      #        return nil if player.blank? || enemy.blank?
      #        player.scene.id
      #      end

      def select_fight_self_info
        [[["地",-1],["水",-2],["火",-3],["风",-4]],[["地",-1],["水",-2],["火",-3],["风",-4]],[["地",-1],["水",-2],["火",-3],["风",-4]],[["地",-1],["水",-2],["火",-3],["风",-4]],[["地",-1],["水",-2],["火",-3],["风",-4]]]
      end

      def select_fight
        [[["地",-1],["水",-2],["火",-3],["风",-4]],[["地",-1],["水",-2],["火",-3],["风",-4]],[["地",-1],["水",-2],["火",-3],["风",-4]],[["地",-1],["水",-2],["火",-3],["风",-4]],[["地",-1],["水",-2],["火",-3],["风",-4]]]
      end

      def new_round
        @action=""
      end

 
      def contrast(a,b)
        return 0 if a== 0
        return 2 if b== 0
        if a%4==b-1
          return 2
        elsif b%4==a-1
          return 0
        else
          return 1
        end
      end



    end
  end
end
