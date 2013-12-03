require 'test_helper'

class DatabaseCachedAttributeTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, DatabaseCachedAttribute
  end
end
