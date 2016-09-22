class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :moments, dependent: :destroy

  before_save :set_uuid

  def set_uuid
    self.uuid = Digest::SHA1.hexdigest(User.count.to_s + Time.now.to_s)[0..9] if self.uuid.blank?
  end

end
