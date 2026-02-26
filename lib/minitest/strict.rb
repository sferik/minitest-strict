require "minitest/assertions"
require_relative "strict/version"

##
# Minitest extensions for strict boolean assertions.

module Minitest
  ##
  # Strict assertion methods that require literal +true+ or +false+
  # return values instead of truthy or falsey.
  module Assertions
    ##
    # Fails unless +obj+ is literally +true+ (not just truthy).

    def assert_true obj, msg = nil
      msg = message(msg) { "Expected #{mu_pp obj} to be true" }
      assert obj.equal?(true), msg
    end

    ##
    # Fails unless +obj+ is literally +false+ (not just falsey).

    def assert_false obj, msg = nil
      msg = message(msg) { "Expected #{mu_pp obj} to be false" }
      assert obj.equal?(false), msg
    end

    ##
    # Fails if +obj+ is literally +true+.

    def refute_true obj, msg = nil
      msg = message(msg) { "Expected true to not be true" }
      refute obj.equal?(true), msg
    end

    ##
    # Fails if +obj+ is literally +false+.

    def refute_false obj, msg = nil
      msg = message(msg) { "Expected false to not be false" }
      refute obj.equal?(false), msg
    end

    ##
    # Fails unless +act+ is eql? to +exp+. Uses +Object#eql?+ for
    # equality without type coercion. Eg:
    #
    #   assert_eql 1, 1     # pass
    #   assert_eql 1, 1.0   # fail

    def assert_eql exp, act, msg = nil
      msg = message(msg) { "Expected #{mu_pp act} to be eql? to #{mu_pp exp}" }
      assert exp.eql?(act), msg
    end

    ##
    # Fails if +act+ is eql? to +exp+.

    def refute_eql exp, act, msg = nil
      msg = message(msg) { "Expected #{mu_pp act} to not be eql? to #{mu_pp exp}" }
      refute exp.eql?(act), msg
    end

    # Strict redefinitions -- require boolean return values

    silence = $VERBOSE
    $VERBOSE = nil

    ##
    # Fails unless +o1+ is +op+. Requires +op+ to return literal
    # +true+, not just a truthy value.
    #
    #   assert_predicate str, :empty?

    def assert_predicate o1, op, msg = nil
      assert_respond_to o1, op, include_all: true
      msg = message(msg) { "Expected #{mu_pp o1} to be #{op}" }
      assert_equal true, o1.__send__(op), msg
    end

    ##
    # Fails if +o1+ is +op+. Requires +op+ to return literal
    # +false+, not just a falsey value.
    #
    #   refute_predicate str, :empty?

    def refute_predicate o1, op, msg = nil
      assert_respond_to o1, op, include_all: true
      msg = message(msg) { "Expected #{mu_pp o1} to not be #{op}" }
      assert_equal false, o1.__send__(op), msg
    end

    ##
    # For testing with binary operators. Requires the operator to
    # return literal +true+, not just a truthy value. Falls through
    # to assert_predicate if +o2+ is not given. Eg:
    #
    #   assert_operator 5, :<=, 4

    def assert_operator o1, op, o2 = UNDEFINED, msg = nil
      return assert_predicate o1, op, msg if o2 == UNDEFINED

      assert_respond_to o1, op, include_all: true
      msg = message(msg) { "Expected #{mu_pp o1} to be #{op} #{mu_pp o2}" }
      assert_equal true, o1.__send__(op, o2), msg
    end

    ##
    # For testing with binary operators. Requires the operator to
    # return literal +false+, not just a falsey value. Falls through
    # to refute_predicate if +o2+ is not given. Eg:
    #
    #   refute_operator 1, :>, 2

    def refute_operator o1, op, o2 = UNDEFINED, msg = nil
      return refute_predicate o1, op, msg if o2 == UNDEFINED

      assert_respond_to o1, op, include_all: true
      msg = message(msg) { "Expected #{mu_pp o1} to not be #{op} #{mu_pp o2}" }
      assert_equal false, o1.__send__(op, o2), msg
    end

    ##
    # Fails unless +obj+ is nil. Uses +equal?+ for identity check.

    def assert_nil obj, msg = nil
      msg = message(msg) { "Expected #{mu_pp obj} to be nil" }
      assert obj.equal?(nil), msg
    end

    ##
    # Fails if +obj+ is nil. Uses +equal?+ for identity check.

    def refute_nil obj, msg = nil
      msg = message(msg) { "Expected nil to not be nil" }
      refute obj.equal?(nil), msg
    end

    $VERBOSE = silence
  end
end
