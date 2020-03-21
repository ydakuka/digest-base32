# frozen_string_literal: true

require 'digest/base32_ext'

require 'digest/base32/version'

require 'securerandom'

module Digest
  class Base32
    CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'

    def self.random(length: 16, padding: true)
      unless length.is_a? Integer
        raise TypeError, "Expected #{Integer}, got #{length.class}"
      end

      unless [true, false].include? padding
        raise TypeError, "Expected bool, got #{padding.class}"
      end

      random = +''
      SecureRandom.random_bytes(length).each_byte do |b|
        random << CHARS[b % 32]
      end
      padding ? random.ljust((length / 8.0).ceil * 8, '=') : random
    end
  end
end
