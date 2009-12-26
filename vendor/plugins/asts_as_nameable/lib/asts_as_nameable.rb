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
          make_sure_read_name
          return @name.name if @name
        end

        def name=(value)
          make_sure_read_name
          unless @name.isnamed
            @name.name = value
            @name.isnamed = true
            return @name.name
          end
          nil
        end

        def system_named=(value)
          make_sure_read_name
          @name.name=value
          @name.isnamed = false
          @name.player_id = nil
        end

        def isnamed
          make_sure_read_name
          @name.isnamed
        end

        def who_named
          make_sure_read_name
          @name.player_id
        end

        def who_named=(value)
          make_sure_read_name
          @name.player_id = value
        end
        
        def nameable=(value)
          make_sure_read_name
          @name.nameable_id   =value.id
          @name.nameable_type =value.class.to_s
        end

        def nameable
          make_sure_read_name
          @name
        end

        def name_verify
          make_sure_read_name
          self.nameable=self if @name.nameable_type.blank?
          (self.errors.add_on_blank(:name); return false) unless @name
          (self.errors.add(:name,"name valid");return false) unless @name.valid?
          true
        end

        def save_name
          self.nameable=self if @name.nameable_id.blank?
          @name.save if @name.changed?
        end

        def destroy_name
          self.nameable.destroy if self.nameable
        end

        protected
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
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::Acts::Nameable)
