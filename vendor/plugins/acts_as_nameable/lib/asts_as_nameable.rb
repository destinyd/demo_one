module ActiveRecord #:nodoc:
  module Acts #:nodoc:
    module Nameable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def acts_as_nameable
          #          has_one :name, :as => :nameable, :dependent => :destroy
          before_save :name_verify
          after_save :save_name
          after_destroy :destroy_name
          include ActiveRecord::Acts::Nameable::InstanceMethods
          extend ActiveRecord::Acts::Nameable::SingletonMethods
          before_validation_on_create :give_random_name
        end
      end

      module SingletonMethods
      end

      module InstanceMethods
        @@expiration  = 2.hours.ago

        def could_name?(player_id)
          !self.isnamed and ( is_creator?(player_id) or is_expiration? )
        end

        def name
          name_instance.name
        end

        def name=(value)
          unless name_instance.isnamed
            name_instance.name = value
            name_instance.isnamed = true
            name_instance.name
          end
        end

        def system_named=(value)
          name_instance.name=value
          name_instance.player_id = nil
        end

        def isnamed
          name_instance.isnamed
        end

        def who_named
          name_instance.player
        end

        def who_named=(value)
          if value.class = Fixnum
            name_instance.player_id = value
          else
            name_instance.player = value
          end
        end
        
        def nameable=(value)
          name_instance.nameable_id   = value.id
          name_instance.nameable_type = value.class.to_s
        end

        def nameable
          name_instance
        end

        def name_verify
          self.nameable=self if name_instance.nameable_type.blank?
          (self.errors.add_on_blank(:name); return false) unless name_instance
          (self.errors.add(:name,"name valid");return false) unless name_instance.valid?
          true
        end

        def save_name
          self.nameable=self if name_instance.nameable_id.blank?
          name_instance.save if name_instance.changed? and name_instance.valid?
        end

        def destroy_name
          self.nameable.destroy if self.nameable
        end

        protected
        def random_name
          "#{self.class.human_name}#{self.time_string}"
        end

        def time_string
          Time.now.strftime("%Y%m%d%H%M%S") + sprintf("%04d",rand(10000))
        end
        def give_random_name
          self.system_named = random_name if self.name.blank?
        end

        def is_creator?(player_id)
          self.player_id == player_id
        end

        def is_expiration?
          self.created_at < @@expiration
        end

        def find_by_id_and_type(id,type)
          Name.find(:first,:conditions => {:nameable_id => id,:nameable_type => type})
        end
        def find_by_self
          find_by_id_and_type(self.id,self.class.to_s)
        end
        def make_sure_read_name
          @name=find_by_self unless @name
          @name = Name.new unless @name
        end
        def name_instance
          return @name if @name
          @name=find_by_self unless @name
          @name = Name.new unless @name
          @name
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::Acts::Nameable)
