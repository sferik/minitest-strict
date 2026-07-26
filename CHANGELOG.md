# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2026-07-26

### Fixed

- `refute_match` no longer always fails on Minitest 6, which reimplemented it
  via `refute_operator`. Since `=~` returns `nil` or an `Integer` — never
  `false` — the strict `refute_operator` rejected every non-match.
  minitest-strict now defines `refute_match` directly, restoring the standard
  Minitest 5 behavior. ([#1](https://github.com/sferik/minitest-strict/issues/1))

## [1.0.0] - 2026-02-26

### Added

- `assert_true` / `refute_true` — assert a value is literally `true`, not just truthy
- `assert_false` / `refute_false` — assert a value is literally `false`, not just falsey
- `assert_eql` / `refute_eql` — assert equality using `eql?` instead of `==`
- Strict `assert_predicate` / `refute_predicate` — require predicates to return `true` or `false`
- Strict `assert_operator` / `refute_operator` — require operators to return `true` or `false`
- Strict `assert_nil` / `refute_nil` — use `equal?` identity check instead of `nil?`
