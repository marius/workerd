require 'test_helper'
require 'init'

class WorkerdTest < ActiveSupport::TestCase
  setup do
    @workerd = Workerd.new
  end

  test "work?" do
    assert_equal true, @workerd.work?
  end

  test "work" do
    #assert_equal true, @workerd.work?
    #@workerd.work
    #assert_equal false, @workerd.work?
  end
end
