# To change this template, choose Tools | Templates
# and open the template in the editor.

module GameDiyWar
  class Output
    class << self
      attr_accessor :output
      def attack(hp,*name)
        @output ||= []
        @output.push "#{name[0]}对#{other(name)}造成#{hp}点伤害"
      end
      
      def capital(hp,*name)
        @output ||= []
        @output.push "#{name[0]}对#{other(name)}致命一击造成了#{hp}点伤害"
      end

      def avoid(*name)
        @output ||= []
        @output.push "#{name[0]}的攻击被#{other(name)}躲过了"
      end

      def learn(*name)
        @output ||= []
        @output.push "#{name[0]}习得技能#{name[1]}"
      end

      def clear
        @output = []
      end

      def get_money(*name)
        @output ||= []
        @output.push "#{other(name)}获得了 #{name[0]} 金币"
      end

      def mhp_up(hp,*name)
        @output ||= []
        @output.push "#{name.join(',')}HP最大值提升#{hp}点"
      end

      def use_skill(damage,skill_name,*name)
        @output ||= []
        @output.push "#{name[0]}使用技能'#{skill_name}'对#{other(name)}造成了#{damage}点伤害"
      end



      private
      def other(name)
        name[1..name.length-1].join(",")
      end
    end
  end
end
