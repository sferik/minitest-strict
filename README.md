# `minitest-strict`

[![Test](https://github.com/sferik/minitest-strict/actions/workflows/test.yml/badge.svg)](https://github.com/sferik/minitest-strict/actions/workflows/test.yml)
[![Lint](https://github.com/sferik/minitest-strict/actions/workflows/lint.yml/badge.svg)](https://github.com/sferik/minitest-strict/actions/workflows/lint.yml)
[![RDoc Coverage](https://github.com/sferik/minitest-strict/actions/workflows/rdoc_coverage.yml/badge.svg)](https://github.com/sferik/minitest-strict/actions/workflows/rdoc_coverage.yml)
[![Mutant](https://github.com/sferik/minitest-strict/actions/workflows/mutant.yml/badge.svg)](https://github.com/sferik/minitest-strict/actions/workflows/mutant.yml)
[![Steep](https://github.com/sferik/minitest-strict/actions/workflows/steep.yml/badge.svg)](https://github.com/sferik/minitest-strict/actions/workflows/steep.yml)
[![Gem Version](https://badge.fury.io/rb/minitest-strict.svg)](https://badge.fury.io/rb/minitest-strict)

#### Strict assertions for [Minitest](https://github.com/minitest/minitest).

## Motivation

Minitest's built-in assertions are lenient in ways that can mask bugs:

- `assert`, `assert_predicate`, and `assert_operator` pass for any truthy return value, not just `true`. A predicate method that accidentally returns `1`, `"yes"`, or an object will silently pass.
- `refute`, `refute_predicate`, and `refute_operator` pass for any falsey return value, not just `false`. A method that returns `nil` instead of `false` won't be caught.
- `assert_nil` and `refute_nil` call `nil?`, which can be overridden on an object and mask bugs.
- There's no built-in assertion that a value is exactly `true` or exactly `false`.
- There's no built-in assertion for `eql?` equality (e.g. distinguishing `1` from `1.0`).

`minitest-strict` fixes all of this. It redefines several Minitest assertions to require strict boolean return values and adds `assert_true`, `assert_false`, and `assert_eql` (with corresponding refutations).

Strict assertions also make mutation testing with [Mutant](https://github.com/mbj/mutant) more effective. When assertions accept only exact boolean values, mutations like replacing `true` with `false` or swapping `nil` for `false` are reliably caught — mutations that lenient assertions would let survive.

## Installation

Add to your Gemfile:

```ruby
gem "minitest-strict"
```

Then require it in your test helper:

```ruby
require "minitest/autorun"
require "minitest/strict"
```

## New Assertions

### `assert_true` / `refute_true`

Passes only when the value is exactly `true` — not merely truthy.

```ruby
assert_true true      # pass
assert_true 1         # fail
assert_true "yes"     # fail
assert_true nil       # fail

refute_true false     # pass
refute_true nil       # pass
refute_true 1         # pass
refute_true true      # fail
```

### `assert_false` / `refute_false`

Passes only when the value is exactly `false` — not merely falsey.

```ruby
assert_false false    # pass
assert_false nil      # fail
assert_false 0        # fail
assert_false ""       # fail

refute_false true     # pass
refute_false nil      # pass
refute_false 0        # pass
refute_false false    # fail
```

### `assert_eql` / `refute_eql`

> [!NOTE]
> `1 == 1.0` is `true` in Ruby, but `1.eql?(1.0)` is `false`. Be mindful of this distinction when comparing numeric values.

Uses `eql?` instead of `==` for a stricter equality check. This distinguishes values that are `==` but not the same type.

```ruby
assert_eql 1, 1         # pass
assert_eql "foo", "foo"  # pass
assert_eql 1, 1.0       # fail — 1 == 1.0 is true, but 1.eql?(1.0) is false

refute_eql 1, 1.0       # pass
refute_eql 1, 2         # pass
refute_eql 1, 1         # fail
```

## Strict Redefinitions

> [!IMPORTANT]
> The following Minitest assertions are **redefined** to require exact boolean return values. Existing tests may fail if the methods under test return truthy/falsey values instead of `true`/`false`.

### `assert_predicate` / `refute_predicate`

> [!WARNING]
> Methods like `Numeric#nonzero?` return `self` or `nil` instead of `true` or `false`. These will fail with minitest-strict's `assert_predicate` and `refute_predicate`.

Standard Minitest accepts any truthy/falsey return value. minitest-strict requires predicates to return exactly `true` or `false`.

```ruby
assert_predicate "", :empty?        # pass — String#empty? returns true
assert_predicate "hello", :empty?   # fail — returns false

# Catches methods that return truthy values other than true:
assert_predicate 1, :nonzero?       # fail — returns 1, not true

refute_predicate "hello", :empty?   # pass — returns false
refute_predicate "", :empty?        # fail — returns true

# Catches methods that return falsey values other than false:
refute_predicate 0, :nonzero?       # fail — returns nil, not false
```

### `assert_operator` / `refute_operator`

Requires operators to return exactly `true` or `false`.

```ruby
assert_operator 1, :<, 2           # pass — returns true
assert_operator 2, :<, 1           # fail — returns false

refute_operator 2, :<, 1           # pass — returns false
refute_operator 1, :<, 2           # fail — returns true

# Catches operators that return non-boolean values:
obj.define_singleton_method(:<=>) { |_| 1 }
assert_operator obj, :<=>, 2       # fail — returns 1, not true
```

### `assert_nil` / `refute_nil`

> [!NOTE]
> The standard Minitest implementation calls `nil?`, which can be overridden. minitest-strict uses `equal?` (identity) instead, so only the actual `nil` object passes.

Uses `equal?` (identity) instead of `nil?`, so objects that override `nil?` can't fool the check.

```ruby
assert_nil nil                     # pass
assert_nil false                   # fail

# Can't be tricked by overriding nil?
obj.define_singleton_method(:nil?) { true }
assert_nil obj                     # fail — obj is not nil

refute_nil 1                       # pass
refute_nil false                   # pass
refute_nil nil                     # fail
```

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).
