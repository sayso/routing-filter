$:.unshift File.expand_path('../lib', __FILE__)
require 'routing_filter/version'

Gem::Specification.new do |s|
  s.name         = "sayso-routing-filter"
  s.version      = RoutingFilter::VERSION
  s.authors      = ["SaySo"]
  s.email        = "sayso@truvolabs.com"
  s.homepage     = "http://github.com/sayso/routing-filter"
  s.summary      = "Routing filters wraps around the complex beast that the Rails routing system is, allowing for unseen flexibility and power in Rails URL recognition and generation - forked and gemified for sayso"
  s.description  = "Routing filters wraps around the complex beast that the Rails routing system is, allowing for unseen flexibility and power in Rails URL recognition and generation - forked and gemified for sayso"

  s.files        = Dir["{lib,test}/**/**"] + Dir['[A-Z]*']
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'

  s.add_dependency 'actionpack'
  s.add_dependency 'configatron'
  s.add_development_dependency 'i18n'
  s.add_development_dependency 'rails'
  s.add_development_dependency 'test_declarative'
end
