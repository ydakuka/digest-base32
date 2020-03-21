# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/extensiontask'

spec = Gem::Specification.load('digest-base32.gemspec')
Rake::ExtensionTask.new('digest/base32_ext', spec)

task default: %i[test lint]

task test: :spec

task lint: :rubocop

task fix: 'rubocop:auto_correct'

task :benchmark do
  require_relative './benchmark'
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(test: %i[clean clobber compile])
rescue LoadError
  nil
end

begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
rescue LoadError
  nil
end
