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
  gem.homepage      = 'https://github.com/ryanmoran/bastille'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'gibberish'
  gem.add_dependency 'highline'
  gem.add_dependency 'httparty'
  gem.add_dependency 'multi_json'
  gem.add_dependency 'octokit'
  gem.add_dependency 'redis'
  gem.add_dependency 'redis-namespace'
  gem.add_dependency 'sinatra'
  gem.add_dependency 'thor'

  gem.add_development_dependency 'aruba'
  gem.add_development_dependency 'mimic'
  gem.add_development_dependency 'fakeredis'
end
