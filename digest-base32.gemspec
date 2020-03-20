# frozen_string_literal: true

lib = File.expand_path('lib', __dir__).freeze
$LOAD_PATH.unshift lib unless $LOAD_PATH.include? lib

require 'digest/base32/version'

Gem::Specification.new do |spec|
  spec.name     = 'digest-base32'
  spec.version  = Digest::Base32::VERSION
  spec.license  = 'MIT'
  spec.homepage = 'https://github.com/ydakuka/digest-base32'
  spec.summary  = 'Base32 Ruby C Extension'
  spec.platform = Gem::Platform::RUBY

  spec.authors = ['James Cook']

  spec.description = <<-DESCRIPTION.split.join ' '
    Ruby native extension for base32 encoding and decoding.
  DESCRIPTION

  spec.metadata = {
    'homepage_uri'    => 'https://github.com/ydakuka/digest-base32',
    'source_code_uri' => 'https://github.com/ydakuka/digest-base32',
    'bug_tracker_uri' =>
      'https://github.com/ydakuka/digest-base32/issues',
  }.freeze

  spec.bindir        = 'exe'
  spec.require_paths = ['lib']

  spec.files = Dir[
    'README.md',
    'LICENSE',
    'Makefile',
    'digest-base32.gemspec',
    'ext/**/*.{c,h,rb}',
    'lib/**/*.{rb}',
  ]

  spec.executables = spec.files.grep %r{^exe/}, &File.method(:basename)

  spec.extensions << 'ext/digest/base32/extconf.rb'

  spec.add_development_dependency 'bundler',       '~> 2'
  spec.add_development_dependency 'minitest',      '~> 5'
  spec.add_development_dependency 'pry',           '~> 0.12'
  spec.add_development_dependency 'rake',          '~> 10'
  spec.add_development_dependency 'rake-compiler', '~> 1'
end
