lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubocop_automata/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubocop-automata'
  spec.version       = RubocopAutomata::VERSION
  spec.authors       = ['rvillage']
  spec.email         = ['rvillage@gmail.com']

  spec.summary       = 'Create GitHub PullRequest of rubocop --autocorrect in CircleCI'
  spec.description   = 'For rubocop --autocorrect. Use in CircleCI'
  spec.homepage      = 'https://github.com/rvillage/rubocop-automata'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rubocop'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
end
