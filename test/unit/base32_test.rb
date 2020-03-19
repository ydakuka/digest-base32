require_relative "../../lib/digest/base32"
require "minitest/autorun"

describe 'Digest::Base32' do
  describe ".encode with no arguments" do
    it "returns an argument error" do
      assert_raises ArgumentError do
        Digest::Base32.encode
      end
    end
  end

  describe ".encode32 given a non-string" do
    it "returns a type error" do
      assert_raises TypeError do
        Digest::Base32.encode(-1)
      end
    end
  end

  describe ".encode32 given a string" do
    it "returns the base32 of the string" do
      str = "hello world! 平仮名"
      result = Digest::Base32.encode(str)
      assert_equal 'NBSWY3DPEB3W64TMMQQSBZNZWPSLXLXFSCGQ====', result
    end
  end

  describe ".decode32 given an encoded string" do
    it "returns the decoded string" do
      str = "hello world! 平仮名"
      encoded = Digest::Base32.encode(str)
      result = Digest::Base32.decode(encoded)
      assert_equal str.force_encoding("ASCII-8BIT"), result
    end
  end
end
