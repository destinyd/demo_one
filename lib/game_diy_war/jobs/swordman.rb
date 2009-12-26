module GameDiyWar
  module Jobs
    module Swordman
      JOB = :swordman

      attr_accessor :skill_hits
      def order(*order)
        bool=false
        if !@action.blank?
          action=@action.split("\;")
          bool=!action[0].blank? && action[1].blank?
        end
        if bool
          eb= order_eb(order[1])
          neworder="#{action[0]};#{eb}"
        else
          neworder = order_to_str(order[0],order[1])
        end
        super(neworder)
      end

      def random_action
        r1 = rand(3)-3
        r2 = rand(3)-3
        order(r1,r2)
      end

      def fight_self(e)
        e.name+="的分身"
        mul = get_mul(self, e)
        if mul == 0
          Output.avoid(@name,e.name)
        elsif mul == 2
          damage = get_damage(self, mul)
          e.hp-= damage
          Output.capital(damage, @name,e.name)
        else
          damage = get_damage(self, mul)
          y.hp -= damage
          Output.attack(damage, @name,e.name)
        end
        add_plus(self)

        mul = get_mul(e,self)
        if mul == 0
          Output.avoid(e.name,@name)
        elsif mul == 2
          damage = get_damage(e, mul)
          @hp -= damage
          save_skill if @plus.length >=3
          clear_plus
          Output.capital(damage,e.name , @name)
        else
          damage = get_damage(e, mul)
          @hp -= damage
          save_skill if @plus.length >=3 # 只有被重击到才可以中断
          clear_plus
          Output.attack(damage,e.name , @name)
        end
      end

      def fight(e)
        mul = get_mul(self, e)
        if mul == 0
          Output.avoid(@name,e.name)
        elsif mul == 2
          damage = get_damage(self, mul)
          e.hp-= damage
          Output.capital(damage, @name,e.name)
        else
          damage = get_damage(self, mul)
          e.hp -= damage
          Output.attack(damage, @name,e.name)
        end
      end

      def adventure_fight(enemies)
        enemy       = enemies.select{|e| e.side != @side and e.alive?}
        adventurer  = Adventurer.find(@adventurer_id,:include => [:player,:skills])
        skills      = adventurer.skills.map{|s| [s.name,s.hits.length]}
        mul         = 1
        damage      = get_damage(self, mul)
        unless enemy.blank?
          if rand() >=0.5 #一半机能 使用机能  攻击次数同技能
            skill = skills[rand(skills.count)]
            damage  = damage  * skill[1]
            e = enemy[rand(enemy.count)]
            e.hp -=  damage
            Output.use_skill(damage, skill[0], @name,e.name)
          else #否则为普通攻击
            e = enemy[rand(enemy.count)]
            e.hp -=  damage
          end
        end
      end


      def save_skill
        skill=find_or_create_skill
        adventurer=Adventurer.find(@adventurer_id,:include => :player)
        skills = adventurer.skills
        unless skills.include?(skill)
          adventurer.skills << skill
          Output.learn(adventurer.player.name,skill.name)
        end
      end

      def save_special
        save_skill if @plus.length >=3
      end

      def find_or_create_skill
        skill=Skill.find(:first,:conditions => {:hits => @plus,:job => GameDiyWar::Constant::jobs.index(JOB)})
        return skill unless skill.blank?
        skill=Skill.new(:hits => @plus,:job => GameDiyWar::Constant::jobs.index(JOB))
        skill.system_named = random_name
        skill.player_id = Adventurer.find(@adventurer_id).player.id
        skill.save
        skill
      end

      def random_name
        "剑技" + Time.now.strftime("%Y%m%d%H%M%S")+sprintf("%04d",rand(99))
      end



      def create
        adventurer=Adventurer.find(@adventurer_id)
        scene=Scene.create
        player=Fighter.create(
          :hp => adventurer.hp ,
          :mhp => adventurer.mhp,
          :job => 1,
          :weapon_id => adventurer.weapon_id,
          :armor_id => adventurer.armor_id,
          :scene_id => scene.id,
          :adventurer_id => adventurer.id
        )
        enemy=Fighter.create(
          :hp => adventurer.hp ,
          :mhp => adventurer.mhp,
          :job => 1,
          :weapon_id => adventurer.weapon_id,
          :armor_id => adventurer.armor_id,
          :side => 1,
          :scene_id => scene.id,
          :adventurer_id => adventurer.id
        )
        return nil if player.blank? || enemy.blank?
        player.scene.id
      end

      def select_fight_self_info
        [[["横斩",-1],["重劈",-2],["直刺",-3]],[["下蹲",-1],["突进",-2],["侧身",-3]]]
      end

      def select_fight
        skills=get_skills_arr
        [[["横斩",-1],["重劈",-2],["直刺",-3]]+skills,[["下蹲",-1],["突进",-2],["侧身",-3]]]
      end

      def new_round
        return @action="" if @action.blank?
        pa=@action.split("\;")[0]
        hits=pa.split(":")[0]
        name=pa.split(":")[2]
        len=pa.split(":")[1].to_i+1
        @action =  hits[len].blank? ? "" : "#{hits}:#{len}:#{name}"
        #          @action=""
        #        else
        #          @action="#{hits}:#{len}:#{name}"
        #        end
      end




      def get_skills_arr
        Adventurer.find(@adventurer_id).skills.map{|skill| [skill.name,skill.id] }
      end

      def order_to_str(order1,order2)
        neworder1 = order1.to_i
        if neworder1 >= -3
          case neworder1
            #          when 0 then neworder1 = "0:1:没有动作"
          when -1 then neworder1 = "1:0:横斩"
          when -2 then neworder1 = "2:0:重劈"
          when -3 then neworder1 = "3:0:直刺"
          else
            begin
              skill=Skill.find(neworder1)
              neworder1 = "#{skill.hits}:0:#{skill.name}"
            rescue
              neworder1 = "0"
            end
          end
        else
          neworder1 = "0"
        end

        neworder2 = order2.to_i
        case neworder2
          #          when 0 then neworder2 = "0:1:没有动作"
        when -1 then neworder2 = "1"
        when -2 then neworder2 = "2"
        when -3 then neworder2 = "3"
        else
          neworder2 = "0"
        end
        "#{neworder1};#{neworder2}"

      end

      def order_eb(order)
        neworder2 = order.to_i
        case neworder2
          #          when 0 then neworder2 = "0:1:没有动作"
        when -1 then neworder2 = "1"
        when -2 then neworder2 = "2"
        when -3 then neworder2 = "3"
        else
          neworder2 = "0"
        end
        "#{neworder2}"
      end

      def contrast(a,b)
        return 0 if a== 0 || a==b
        return 2 if b== 0
        if (a+1)%3+1==b
          return 2
        else
          return 1
        end
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

      def get_mul(p,e)
        if !p.action.blank?
          pa=get_pa(p)
        else
          pa=0
        end
        if !e.action.blank?
          eb=get_eb(e)
        else
          eb=0
        end
        contrast(pa,eb)
      end

      def get_pa(p)
        pa=p.action.split("\;")[0].split(":")
        hits=pa[0]
        return hits.to_i if hits.length == 1
        len=pa[1].to_i
        hits[len..len].to_i
      end
      
      def get_eb(e)
        eb=e.action.split("\;")[1]
        return 0 unless eb
        eb.split(":")[0].to_i
      end

      def add_plus(p)
        pa=get_pa(p)
        @plus +="#{pa}"
      end

      def clear_plus
        @plus=""
      end

      def can_activity?
        (@action.blank? || !@action.split("\;")[1]) && @hp >0
      end


    end
  end
end
