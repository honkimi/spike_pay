# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spike_pay/version'

Gem::Specification.new do |spec|
  spec.name          = "spike_pay"
  spec.version       = SpikePay::VERSION
  spec.authors       = ["Kiminari Homma"]
  spec.email         = ["u533u778@gmail.com"]
  spec.summary       = %q{SPIKE API client for Ruby}
  spec.description   = %q{SPIKE pay enable you to delvelop SPIKE API access easy.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday', '~> 0.8'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "pry-doc"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
