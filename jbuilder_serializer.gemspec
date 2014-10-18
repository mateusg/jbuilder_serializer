lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'jbuilder/serializer/version'

Gem::Specification.new do |spec|
  spec.name          = 'jbuilder_serializer'
  spec.version       = Jbuilder::Serializer::VERSION
  spec.authors       = ['Mateus Gomes']
  spec.email         = ['mateusg.18@gmail.com']
  spec.description   = 'Allows creation of serializer classes integrated with jbuilder views'
  spec.summary       = 'Allows creation of serializer classes integrated with jbuilder views'
  spec.homepage      = 'https://github.com/mateusg/jbuilder_serializer'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'actionpack', '~> 4.0'
  spec.add_dependency 'jbuilder', '~> 2.2.2'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
