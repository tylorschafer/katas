require 'test/unit'
require './foo'

class FooTest < Test::Unit::TestCase

  def test_foo_greets_a_person
    foo = Foo.new("Mark")
    assert_equal "Hello, Mark!", foo.greet
  end
  
  def test_your_response_isnt_hard_coded
    foo = Foo.new("Bill")
    assert_equal "Hello, Bill!", foo.greet
  end
  
end