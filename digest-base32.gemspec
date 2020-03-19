require_relative "./lib/digest/base32/version"

Gem::Specification.new do |s|
  s.name     = "digest-base32"
  s.version  = Digest::Base32::VERSION
  s.summary  = "Base32 Ruby C Extension"
  s.author   = "James Cook"
  s.platform = Gem::Platform::RUBY
  s.homepage = "https://github.com/ydakuka/digest-base32"

  s.files = Dir.glob("ext/digest/**/*.{c,h,rb}") +
            Dir.glob("lib/digest/**/*.{rb}")

  s.extensions << "ext/digest/base32/extconf.rb"
  s.licenses << "MIT"

  s.add_development_dependency "rake-compiler", "~> 1"
  s.add_development_dependency "minitest", "~> 5"
  s.required_ruby_version = '>= 2.2'
end
