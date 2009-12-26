class Name < ActiveRecord::Base
  validates_length_of :name, :within => 2..32
  validates_uniqueness_of :name
  validates_presence_of   :name,:nameable_type
  belongs_to :nameable, :polymorphic => true
end
