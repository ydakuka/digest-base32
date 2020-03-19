require 'base32' # Install separately
require 'digest-base32'
require 'benchmark'
require 'securerandom'

sample = SecureRandom.hex(512)
puts "Benchmarking encde/decode of random string (#{sample.size} characters) ..."

raise unless Digest::Base32.decode(Digest::Base32.encode(sample)) == Base32.decode(Base32.encode(sample))

encoded = Base32.encode(sample)

Benchmark.bmbm do |x|
  x.report("base32 pure ruby (encode)".rjust(30))   { 1_000.times { Base32.encode(sample) } }
  x.report("base32 c extension (encode)".rjust(30)) { 1_000.times { Digest::Base32.encode(sample) } }
  x.report("base32 pure ruby (decode)".rjust(30))   { 1_000.times { Base32.decode(encoded) } }
  x.report("base32 c extension (decode)".rjust(30)) { 1_000.times { Digest::Base32.decode(encoded) } }
end

