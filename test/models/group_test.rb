require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  test "Defaults are used when preferences are blank" do
    g = Group.new 
    assert g.preferences.eql?(Group.default_preferences)
  end

  test "#moments returns all moments belonging to members" do
    g = Group.find_by(name: "GroupOne")

    puts "membership " + Membership.count.to_s
    puts "g users " + g.users.count.to_s
    puts g.inspect
    puts Membership.first.inspect
    puts Membership.first.user.inspect

    moments_total = 0
    User.all.each { |u| moments_total+=u.moments.count }
    assert g.moments.count.eql?(moments_total)
  end
end
