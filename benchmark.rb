# frozen_string_literal: true

require 'base32'
require 'digest/base32'
require 'benchmark'
require 'securerandom'

sample = SecureRandom.hex(512)

puts(
  "Benchmarking encode/decode of random string (#{sample.size} characters) ...",
)

digest_base32_sample = Digest::Base32.decode(Digest::Base32.encode(sample))
base32_sample = Base32.decode(Base32.encode(sample))

raise unless digest_base32_sample == base32_sample

encoded = Base32.encode(sample)

Benchmark.bmbm do |x|
  x.report('base32 pure ruby (encode)'.rjust(30)) do
    1_000.times { Base32.encode(sample) }
  end

  x.report('base32 c extension (encode)'.rjust(30)) do
    1_000.times { Digest::Base32.encode(sample) }
  end

  x.report('base32 pure ruby (decode)'.rjust(30)) do
    1_000.times { Base32.decode(encoded) }
  end

  x.report('base32 c extension (decode)'.rjust(30)) do
    1_000.times { Digest::Base32.decode(encoded) }
  end
end
