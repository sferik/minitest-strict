require_relative "lib/minitest/strict/version"

Gem::Specification.new do |spec|
  spec.name = "minitest-strict"
  spec.version = Minitest::Strict::VERSION
  spec.authors = ["Erik Berlin"]
  spec.email = ["sferik@gmail.com"]
  spec.summary = "Strict assertions for Minitest"
  spec.description = "Redefines Minitest assertions to require strict boolean return values " \
                     "and adds assert_true, assert_false, and assert_eql."
  spec.homepage = "https://sferik.github.io/minitest-strict"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2"
  spec.metadata = {
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/sferik/minitest-strict",
    "bug_tracker_uri" => "https://github.com/sferik/minitest-strict/issues",
    "changelog_uri" => "https://github.com/sferik/minitest-strict/blob/main/CHANGELOG.md",
    "documentation_uri" => "https://www.rubydoc.info/gems/minitest-strict"
  }

  spec.files = Dir["lib/**/*.rb", "CHANGELOG.md", "LICENSE.txt", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "minitest", ">= 5.21", "< 7"
end
