class Feature < ApplicationRecord
  
  serialize :data, Hash
  validates :data, presence: true
  validates :moment_id, presence: true

  belongs_to :moment
end
