# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sii_chile/version'

Gem::Specification.new do |gem|
  gem.name          = "sii_chile"
  gem.version       = SIIChile::VERSION
  gem.authors       = ["Seba Gamboa"]
  gem.email         = ["me@sagmor.com"]
  gem.description   = %q{Ruby API to some services from sii.cl}
  gem.summary       = %q{Ruby API to some services from sii.cl}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/) rescue []
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency "faraday"
  gem.add_dependency "nokogiri"
  gem.add_development_dependency "rake"
end
