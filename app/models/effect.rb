class Effect < ActiveRecord::Base
  has_many :player_effects, :dependent => :destroy
  has_many :players, :through => :player_effects
  validates_presence_of :prototype

  acts_as_nameable
  protected
end
