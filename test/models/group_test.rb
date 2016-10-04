require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  test "Defaults are used when preferences are blank" do
    g = Group.new 
    assert g.preferences.eql?(Group.default_preferences)
  end
end
