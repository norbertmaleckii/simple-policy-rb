# frozen_string_literal: true

require_relative 'lib/simple_policy/version'

Gem::Specification.new do |spec|
  spec.name          = 'simple_policy'
  spec.version       = SimplePolicy::VERSION
  spec.authors       = ['Norbert Małecki']
  spec.email         = ['norbert.malecki@icloud.com']

  spec.summary       = 'Policy system for Ruby with awesome features!'
  spec.description   = [
    'Helps you to define policy in a simple way.',
    'Define your policies in classses, it means you can separate them from models and reuse them.'
  ].join(' ')

  spec.homepage      = 'https://github.com/norbertmaleckii/simple-policy-rb'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.5.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/CHANGELOG.md"
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'pry'
end
