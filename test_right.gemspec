# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{test_right}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Eric Allen", "Sean Grove"]
  s.date = %q{2011-04-25}
  s.description = %q{An opinionated browser testing framework}
  s.summary = %q{An opinionated browser testing framework}
  s.email = %q{help@saucelabs.com}
  s.files = [
    "LICENSE",
    "README.md",
    "Rakefile",
  ] + Dir.glob("lib/**/*")
  
  s.add_dependency("selenium-webdriver", ">= 0.2.0")
  s.add_dependency("threadz", "~> 0.1.3")

  s.add_development_dependency("mocha", ">= 0.9.12")
end
