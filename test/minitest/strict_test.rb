require "test_helper"

class TestMinitestStrict < Minitest::Test
  cover "Minitest::Assertions*"

  class DummyTest
    include Minitest::Assertions

    attr_accessor :assertions

    def initialize
      self.assertions = 0
    end
  end

  def setup
    super

    @tc = DummyTest.new
    @assertion_count = 1
  end

  def teardown
    msg = "expected #{@assertion_count} assertions to be fired during the test, not #{@tc.assertions}"

    assert_equal @assertion_count, @tc.assertions, msg
  end

  def assert_triggered(expected, klass = Minitest::Assertion, &)
    e = assert_raises(klass, &)

    msg = e.message.sub(/(---Backtrace---).*/m, '\1')
    msg.gsub!(/\(oid=[-0-9]+\)/, "(oid=N)")

    if expected.is_a?(Regexp)
      assert_match expected, msg
    else
      assert_equal expected, msg
    end
  end

  # assert_true

  def test_assert_true
    @tc.assert_true true
  end

  def test_assert_true__triggered_false
    assert_triggered "Expected false to be true." do
      @tc.assert_true false
    end
  end

  def test_assert_true__triggered_truthy
    assert_triggered "Expected 1 to be true." do
      @tc.assert_true 1
    end
  end

  def test_assert_true__triggered_nil
    assert_triggered "Expected nil to be true." do
      @tc.assert_true nil
    end
  end

  def test_assert_true__custom_message
    assert_triggered(/custom/) do
      @tc.assert_true false, "custom"
    end
  end

  # assert_false

  def test_assert_false
    @tc.assert_false false
  end

  def test_assert_false__triggered_true
    assert_triggered "Expected true to be false." do
      @tc.assert_false true
    end
  end

  def test_assert_false__triggered_nil
    assert_triggered "Expected nil to be false." do
      @tc.assert_false nil
    end
  end

  def test_assert_false__triggered_falsey
    assert_triggered "Expected 0 to be false." do
      @tc.assert_false 0
    end
  end

  def test_assert_false__custom_message
    assert_triggered(/custom/) do
      @tc.assert_false true, "custom"
    end
  end

  # refute_true

  def test_refute_true
    @tc.refute_true false
  end

  def test_refute_true_truthy
    @tc.refute_true 1
  end

  def test_refute_true_nil
    @tc.refute_true nil
  end

  def test_refute_true__triggered
    assert_triggered "Expected true to not be true." do
      @tc.refute_true true
    end
  end

  def test_refute_true__custom_message
    assert_triggered(/custom/) do
      @tc.refute_true true, "custom"
    end
  end

  # refute_false

  def test_refute_false
    @tc.refute_false true
  end

  def test_refute_false_nil
    @tc.refute_false nil
  end

  def test_refute_false__triggered
    assert_triggered "Expected false to not be false." do
      @tc.refute_false false
    end
  end

  def test_refute_false__custom_message
    assert_triggered(/custom/) do
      @tc.refute_false false, "custom"
    end
  end

  # assert_eql

  def test_assert_eql
    @tc.assert_eql 1, 1
  end

  def test_assert_eql__triggered
    assert_triggered "Expected 1.0 to be eql? to 1." do
      @tc.assert_eql 1, 1.0
    end
  end

  def test_assert_eql__triggered_string
    assert_triggered 'Expected "bar" to be eql? to "foo".' do
      @tc.assert_eql "foo", "bar"
    end
  end

  def test_assert_eql__custom_message
    assert_triggered(/custom/) do
      @tc.assert_eql 1, 1.0, "custom"
    end
  end

  # refute_eql

  def test_refute_eql
    @tc.refute_eql 1, 1.0
  end

  def test_refute_eql__triggered
    assert_triggered "Expected 1 to not be eql? to 1." do
      @tc.refute_eql 1, 1
    end
  end

  def test_refute_eql__triggered_string
    assert_triggered 'Expected "foo" to not be eql? to "foo".' do
      @tc.refute_eql "foo", "foo"
    end
  end

  def test_refute_eql__custom_message
    assert_triggered(/custom/) do
      @tc.refute_eql 1, 1, "custom"
    end
  end

  # assert_predicate (strict)

  def test_assert_predicate
    @assertion_count = 2

    @tc.assert_predicate "", :empty?
  end

  def test_assert_predicate__triggered_truthy
    @assertion_count = 2

    obj = Object.new
    obj.define_singleton_method(:truthy?) { 1 }

    assert_triggered(/Expected.*to be truthy\?/) do
      @tc.assert_predicate obj, :truthy?
    end
  end

  def test_assert_predicate__triggered_false
    @assertion_count = 2

    assert_triggered(/Expected "hello" to be empty\?/) do
      @tc.assert_predicate "hello", :empty?
    end
  end

  def test_assert_predicate__custom_message
    @assertion_count = 2

    assert_triggered(/custom/) do
      @tc.assert_predicate "hello", :empty?, "custom"
    end
  end

  def test_assert_predicate__private_method
    @assertion_count = 2

    obj = Object.new
    obj.define_singleton_method(:secret?) { true }
    obj.singleton_class.send(:private, :secret?)

    @tc.assert_predicate obj, :secret?
  end

  # refute_predicate (strict)

  def test_refute_predicate
    @assertion_count = 2

    @tc.refute_predicate "hello", :empty?
  end

  def test_refute_predicate__triggered_falsey
    @assertion_count = 2

    obj = Object.new
    obj.define_singleton_method(:falsey?) { nil }

    assert_triggered(/Expected.*to not be falsey\?/) do
      @tc.refute_predicate obj, :falsey?
    end
  end

  def test_refute_predicate__triggered_true
    @assertion_count = 2

    assert_triggered(/Expected "" to not be empty\?/) do
      @tc.refute_predicate "", :empty?
    end
  end

  def test_refute_predicate__custom_message
    @assertion_count = 2

    assert_triggered(/custom/) do
      @tc.refute_predicate "", :empty?, "custom"
    end
  end

  def test_refute_predicate__private_method
    @assertion_count = 2

    obj = Object.new
    obj.define_singleton_method(:secret?) { false }
    obj.singleton_class.send(:private, :secret?)

    @tc.refute_predicate obj, :secret?
  end

  # assert_operator (strict)

  def test_assert_operator
    @assertion_count = 2

    @tc.assert_operator 1, :<, 2
  end

  def test_assert_operator__triggered_truthy
    @assertion_count = 2

    obj = Object.new
    obj.define_singleton_method(:<=>) { |_| 1 }

    assert_triggered(/Expected.*to be <=>/) do
      @tc.assert_operator obj, :<=>, 2
    end
  end

  def test_assert_operator__triggered_false
    @assertion_count = 2

    assert_triggered(/Expected "b" to be < "a"/) do
      @tc.assert_operator "b", :<, "a"
    end
  end

  def test_assert_operator__custom_message
    @assertion_count = 2

    assert_triggered(/custom/) do
      @tc.assert_operator 2, :<, 1, "custom"
    end
  end

  def test_assert_operator_unary
    @assertion_count = 2

    @tc.assert_operator "", :empty?
  end

  def test_assert_operator_unary__custom_message
    @assertion_count = 2

    assert_triggered(/custom/) do
      @tc.assert_operator "hello", :empty?, Minitest::Assertions::UNDEFINED, "custom"
    end
  end

  def test_assert_operator__private_method
    @assertion_count = 2

    obj = Object.new
    obj.define_singleton_method(:gt?) { |_| true }
    obj.singleton_class.send(:private, :gt?)

    @tc.assert_operator obj, :gt?, 1
  end

  # refute_operator (strict)

  def test_refute_operator
    @assertion_count = 2

    @tc.refute_operator 2, :<, 1
  end

  def test_refute_operator__triggered_falsey
    @assertion_count = 2

    obj = Object.new
    obj.define_singleton_method(:match?) { |_| nil }

    assert_triggered(/Expected.*to not be match\?/) do
      @tc.refute_operator obj, :match?, "x"
    end
  end

  def test_refute_operator__triggered_true
    @assertion_count = 2

    assert_triggered(/Expected "a" to not be < "b"/) do
      @tc.refute_operator "a", :<, "b"
    end
  end

  def test_refute_operator__custom_message
    @assertion_count = 2

    assert_triggered(/custom/) do
      @tc.refute_operator 1, :<, 2, "custom"
    end
  end

  def test_refute_operator_unary
    @assertion_count = 2

    @tc.refute_operator "hello", :empty?
  end

  def test_refute_operator_unary__custom_message
    @assertion_count = 2

    assert_triggered(/custom/) do
      @tc.refute_operator "", :empty?, Minitest::Assertions::UNDEFINED, "custom"
    end
  end

  def test_refute_operator__private_method
    @assertion_count = 2

    obj = Object.new
    obj.define_singleton_method(:gt?) { |_| false }
    obj.singleton_class.send(:private, :gt?)

    @tc.refute_operator obj, :gt?, 1
  end

  # assert_nil (strict)

  def test_assert_nil
    @tc.assert_nil nil
  end

  def test_assert_nil__triggered_false
    assert_triggered "Expected false to be nil." do
      @tc.assert_nil false
    end
  end

  def test_assert_nil__triggered_custom_nil_predicate
    obj = Object.new
    obj.define_singleton_method(:nil?) { true }
    obj.define_singleton_method(:inspect) { "custom" }

    assert_triggered "Expected custom to be nil." do
      @tc.assert_nil obj
    end
  end

  def test_assert_nil__custom_message
    assert_triggered(/custom/) do
      @tc.assert_nil false, "custom"
    end
  end

  # refute_nil (strict)

  def test_refute_nil
    @tc.refute_nil 1
  end

  def test_refute_nil_false
    @tc.refute_nil false
  end

  def test_refute_nil__custom_nil_predicate
    obj = Object.new
    obj.define_singleton_method(:nil?) { true }

    @tc.refute_nil obj
  end

  def test_refute_nil__triggered
    assert_triggered "Expected nil to not be nil." do
      @tc.refute_nil nil
    end
  end

  def test_refute_nil__custom_message
    assert_triggered(/custom/) do
      @tc.refute_nil nil, "custom"
    end
  end
end
