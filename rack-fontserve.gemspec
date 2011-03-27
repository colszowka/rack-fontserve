# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rack-fontserve/version"

Gem::Specification.new do |s|
  s.name        = "rack-fontserve"
  s.version     = FONTSERVE_VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Christoph Olszowka"]
  s.email       = ["christoph (at) olszowka de"]
  s.homepage    = "https://github.com/colszowka/rack-fontserve"
  s.summary     = %q{Sinatra app for serving web fonts easily with proper caching and access-control headers}
  s.description = %q{Sinatra app for serving web fonts easily with proper caching and access-control headers}

  s.rubyforge_project = "rack-fontserve"
  
  s.add_dependency 'sinatra', "~> 1.2.1"
  
  s.add_development_dependency 'rack-test', "~> 0.5.7"
  s.add_development_dependency 'shoulda', "~> 2.11.3"
  s.add_development_dependency 'simplecov', '>= 0.4.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
