# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'left_joins/version'

Gem::Specification.new do |spec|
  spec.name          = "left_joins"
  spec.version       = LeftJoins::VERSION
  spec.authors       = ["khiav reoy"]
  spec.email         = ["khiav223577@gmail.com"]

  spec.summary       = %q{Backport `left_joins` from Rails 5 for Rails 3 and 4.}
  spec.description   = %q{Backport `left_joins` from Rails 5 for Rails 3 and 4.}
  spec.homepage      = "https://github.com/khiav223577/left_joins"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  #if spec.respond_to?(:metadata)
  #  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  #else
  #  raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  #end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.metadata      = {
    'homepage_uri'      => 'https://github.com/khiav223577/left_joins',
    'changelog_uri'     => 'https://github.com/khiav223577/left_joins/blob/master/CHANGELOG.md',
    'source_code_uri'   => 'https://github.com/khiav223577/left_joins',
    'documentation_uri' => 'https://www.rubydoc.info/gems/left_joins',
    'bug_tracker_uri'   => 'https://github.com/khiav223577/left_joins/issues',
  }

  spec.add_development_dependency 'bundler', '>= 1.17', '< 3.x'
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "sqlite3", "~> 1.3"
  spec.add_development_dependency "minitest", ">= 4.2"
  spec.add_development_dependency "pluck_all", ">= 2.0.2"

  spec.add_dependency "activerecord", ">= 3"

end
