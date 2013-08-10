# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'storehouse_client/version'

Gem::Specification.new do |gem|
  gem.name          = 'storehouse_client'
  gem.version       = StorehouseClient::VERSION
  gem.authors       = StorehouseClient::AUTHORS
  gem.email         = StorehouseClient::EMAIL
  gem.description   = StorehouseClient::DESCRIPTION
  gem.summary       = StorehouseClient::SUMMARY
  gem.homepage      = StorehouseClient::HOMEPAGE

  gem.files = Dir['Rakefile', 'Gemfile', '{bin,lib,man,test,spec}/**/*', 'README*', 'LICENSE*']
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = Dir['{test,spec,features}']

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'gemcutter'
  gem.add_development_dependency 'dnsruby'
  gem.add_development_dependency 'fog'
  gem.add_runtime_dependency 'rest-client'
  gem.add_runtime_dependency 'crack'

end
