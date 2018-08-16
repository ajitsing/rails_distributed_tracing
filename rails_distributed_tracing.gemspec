# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative './lib/rails_distributed_tracing/version.rb'

Gem::Specification.new do |s|
  s.name                        =   'rails_distributed_tracing'
  s.version                     =   DistributedTracing::VERSION
  s.summary                     =   'Microservices distributed tracing'
  s.authors                     =   ['Ajit Singh']
  s.email                       =   'jeetsingh.ajit@gamil.com'
  s.license                     =   'MIT'
  s.homepage                    =   'https://github.com/ajitsing/rails_distributed_tracing'

  s.files                       =   `git ls-files -z`.split("\x0")
  s.executables                 =   s.files.grep(%r{^bin/}) { |f| File.basename(f)  }
  s.test_files                  =   s.files.grep(%r{^(test|spec|features)/})
  s.require_paths               =   ["lib"]

  s.add_development_dependency      "bundler", "~> 1.5"
  s.add_development_dependency      'rspec'
end
