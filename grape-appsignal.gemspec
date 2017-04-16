# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grape-appsignal/version'

Gem::Specification.new do |spec|
  spec.name          = "grape-appsignal"
  spec.version       = Appsignal::Grape::VERSION
  spec.authors       = ["Mark Madsen"]
  spec.email         = ["growl@agileanimal.com"]
  spec.description   = %q{appsignal integration for grape}
  spec.summary       = %q{appsignal integration for grape}
  spec.homepage      = "https://github.com/aai/grape-appsignal"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'appsignal', '~> 0.9'
  spec.add_dependency 'grape', '~> 0.8'

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec', '~> 2.14'
end
