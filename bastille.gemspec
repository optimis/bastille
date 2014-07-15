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
  gem.add_dependency 'httparty', '0.11.0'
  gem.add_dependency 'multi_json'
  gem.add_dependency 'faraday_middleware', '0.9.0'
  gem.add_dependency 'faraday', '0.8.7'
  gem.add_dependency 'octokit', '1.24.0'
  gem.add_dependency 'redis'
  gem.add_dependency 'redis-namespace', '~> 1.2'
  gem.add_dependency 'sinatra'
  gem.add_dependency 'thor'

  gem.add_development_dependency 'aruba'
  gem.add_development_dependency 'mimic'
  gem.add_development_dependency 'fakeredis'
  gem.add_development_dependency 'rspec'
end
