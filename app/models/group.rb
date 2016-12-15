class Group < ApplicationRecord

  validates :name, presence: true
  serialize :preferences, Hash

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  def self.default_preferences
    { show_map: true, is_open_data: false }
  end

  def preferences
    prefs = read_attribute(:preferences)
    
    Group.default_preferences.each do |key,value|
      prefs[key] = value if prefs[key].nil?
    end
    
    return prefs.symbolize_keys
  end

  def admins
    User.joins(:memberships).where('memberships.role = ?', 'admin').where('memberships.group_id = ?', self.id)
  end

  def is_admin?(user)
    admins.include?(user) or user.try(:is_admin)
  end

  def is_group_admin?(user)
    admins.include?(user)
  end

  def is_visible_to(user)
    visible = user and (user.groups.include?(self) or user.is_admin)
    visible
  end

  def self.open
    where(is_private: false)
  end

  def moments(opts={})
    result = Moment.joins(user: :groups).where('groups.id = ? ', id)
    result = result.where("moments.timestamp >= ?", opts[:from]) if opts[:from]
    result = result.where("moments.timestamp <= ?", opts[:to]) if opts[:to]
    result
  end

end
