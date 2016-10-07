require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  test "Defaults are used when preferences are blank" do
    g = Group.new 
    assert g.preferences.eql?(Group.default_preferences)
  end

  test "#moments returns all moments belonging to members" do
    g = Group.first
    moments_total = 0
    User.all.each { |u| moments_total+=u.moments.count; g.users << u }
    assert g.moments.count.eql?(moments_total)
  end
end
