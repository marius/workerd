require 'test_helper'
require 'init'

class WorkerpieceTest < ActiveSupport::TestCase
  test "waiting" do
    assert Workerd::Workpiece.waiting.size > 0
    p workpieces
  end

  test "work" do
    #assert_equal true, @workerd.work?
    #@workerd.work
    #assert_equal false, @workerd.work?
  end
end
