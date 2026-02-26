# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-26

### Added

- `assert_true` / `refute_true` — assert a value is literally `true`, not just truthy
- `assert_false` / `refute_false` — assert a value is literally `false`, not just falsey
- `assert_eql` / `refute_eql` — assert equality using `eql?` instead of `==`
- Strict `assert_predicate` / `refute_predicate` — require predicates to return `true` or `false`
- Strict `assert_operator` / `refute_operator` — require operators to return `true` or `false`
- Strict `assert_nil` / `refute_nil` — use `equal?` identity check instead of `nil?`
