# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'freec/version'

Gem::Specification.new do |spec|
  spec.name          = "freec"
  spec.version       = Freec::VERSION
  spec.authors       = ["Jan Kubr"]
  spec.email         = ["mail@jankubr.com"]

  spec.summary       = "The layer between your Ruby voice app and FreeSWITCH."
  spec.description   = "The layer between your Ruby voice app and FreeSWITCH."
  spec.homepage      = "http://github.com/jankubr/freec"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'gserver', '~> 0.0.1'
  spec.add_runtime_dependency 'daemons', '~> 1.2.4'

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
