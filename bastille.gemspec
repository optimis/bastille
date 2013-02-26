# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bastille/version'

Gem::Specification.new do |gem|
  gem.name          = 'bastille'
  gem.version       = Bastille::VERSION
  gem.authors       = ['Ryan Moran']
  gem.email         = ['ryan.moran@gmail.com']
  gem.description   = %q{KV Storage As a Service, LOLz}
  gem.summary       = %q{KV Storage As a Service, LOLz}
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end
