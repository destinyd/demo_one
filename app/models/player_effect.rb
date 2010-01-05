class PlayerEffect < ActiveRecord::Base
  belongs_to :player
  belongs_to :effect
  belongs_to :scene, :polymorphic => true
  validates_presence_of :player_id
  validates_presence_of :effect_id
end
