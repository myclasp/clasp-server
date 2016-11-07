class Feature < ApplicationRecord
  
  validates :data, presence: true

  belongs_to :moment
end
