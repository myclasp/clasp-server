class Feature < ApplicationRecord
  
  serialize :data, Hash
  validates :data, presence: true

  belongs_to :moment
end
