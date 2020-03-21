# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Digest::Base32 do
  subject { described_class }

  describe '.encode' do
    specify do
      expect(subject.encode('a')).to eq 'ME======'
    end

    specify do
      expect(subject.encode('12345')).to eq 'GEZDGNBV'
    end

    specify do
      expect(subject.encode('abcde')).to eq 'MFRGGZDF'
    end

    context 'when no arguments' do
      specify do
        expect { subject.encode }.to raise_error \
          ArgumentError, 'wrong number of arguments (given 0, expected 1)'
      end
    end

    context 'when given a non-string' do
      let(:value) { rand(-10..10) }

      specify do
        expect { subject.encode(value) }.to raise_error \
          TypeError, 'expected a String'
      end
    end

    context 'when given a string' do
      let(:value) { 'hello world! 平仮名' }

      specify do
        expect(subject.encode(value)).to eq \
          'NBSWY3DPEB3W64TMMQQSBZNZWPSLXLXFSCGQ===='
      end
    end

    context 'when hex and byte string are consider' do
      specify do
        expect(
          subject.encode(hex_to_plain_string('28')),
        ).to eq 'FA======'
      end

      specify do
        expect(
          subject.encode(hex_to_plain_string('d6')),
        ).to eq '2Y======'
      end

      specify do
        expect(
          subject.encode(hex_to_plain_string('d6f8')),
        ).to eq '234A===='
      end

      specify do
        expect(
          subject.encode(hex_to_plain_string('d6f800')),
        ).to eq '234AA==='
      end

      specify do
        expect(
          subject.encode(hex_to_plain_string('d6f810')),
        ).to eq '234BA==='
      end

      specify do
        expect(
          subject.encode(hex_to_plain_string('d6f8110c')),
        ).to eq '234BCDA='
      end

      specify do
        expect(
          subject.encode(hex_to_plain_string('d6f8110c80')),
        ).to eq '234BCDEA'
      end

      specify do
        expect(
          subject.encode(hex_to_plain_string('d6f8110c8530')),
        ).to eq '234BCDEFGA======'
      end

      specify do
        expect(
          subject.encode(hex_to_plain_string('d6f8110c8536b7c0886429')),
        ).to eq '234BCDEFG234BCDEFE======'
      end
    end
  end

  describe '.decode' do
    specify do
      expect(subject.decode('ME======')).to eq 'a'
    end

    specify do
      expect(subject.decode('GEZDGNBV')).to eq '12345'
    end

    specify do
      expect(subject.decode('MFRGGZDF')).to eq 'abcde'
    end

    context 'when no arguments' do
      specify do
        expect { subject.decode }.to raise_error \
          ArgumentError, 'wrong number of arguments (given 0, expected 1)'
      end
    end

    context 'when given a non-string' do
      let(:value) { rand(-10..10) }

      specify do
        expect { subject.decode(value) }.to raise_error \
          TypeError, 'expected a String'
      end
    end

    context 'when given a string' do
      let(:value) { 'hello world! 平仮名' }
      let(:encoded_value) { Digest::Base32.encode(value) }

      specify do
        expect(subject.decode(encoded_value)).to eq \
          value.dup.force_encoding('ASCII-8BIT')
      end
    end

    context 'when hex and byte string are consider' do
      specify do
        expect(
          subject.decode('FA======'),
        ).to eq hex_to_plain_string('28')
      end

      specify do
        expect(
          subject.decode('2Y======'),
        ).to eq hex_to_plain_string('d6')
      end

      specify do
        expect(
          subject.decode('234A===='),
        ).to eq hex_to_plain_string('d6f8')
      end

      xspecify do
        expect(
          subject.decode('234AA==='),
        ).to eq hex_to_plain_string('d6f800')
      end

      specify do
        expect(
          subject.decode('234BA==='),
        ).to eq hex_to_plain_string('d6f810')
      end

      specify do
        expect(
          subject.decode('234BCDA='),
        ).to eq hex_to_plain_string('d6f8110c')
      end

      specify do
        expect(
          subject.decode('234BCDEA'),
        ).to eq hex_to_plain_string('d6f8110c80')
      end

      specify do
        expect(
          subject.decode('234BCDEFGA======'),
        ).to eq hex_to_plain_string('d6f8110c8530')
      end

      specify do
        expect(
          subject.decode('234BCDEFG234BCDEFE======'),
        ).to eq hex_to_plain_string('d6f8110c8536b7c0886429')
      end
    end
  end

  describe '.random' do
    specify do
      expect { subject.random }.not_to raise_error
    end

    specify do
      expect(subject.random).to be_instance_of String
    end

    specify do
      expect(subject.random).not_to be_empty
    end

    specify do
      expect(subject.random).to match(/^[A-Z2-7]+$/)
    end

    specify do
      expect(subject.random.length).to eq 16
    end

    context 'when length has invalid type' do
      let(:length) { rand(1..16).to_s }

      specify do
        expect { subject.random(length: length) }.to raise_error \
          TypeError, "Expected #{Integer}, got #{String}"
      end
    end

    context 'when padding has invalid type' do
      let(:padding) { 'true' }

      specify do
        expect { subject.random(padding: padding) }.to \
          raise_error TypeError, "Expected bool, got #{String}"
      end
    end

    context 'when length is not default' do
      let(:length) { rand 1..1_000 }

      let :padding_regex_string do
        value = length % 8

        value.zero? ? '' : "={#{8 - value}}"
      end

      specify do
        expect(subject.random(length: length).length).to eq \
          (length / 8.0).ceil * 8
      end

      specify do
        expect(subject.random(length: length)).to \
          match(/^[A-Z2-7]{#{length}}#{padding_regex_string}$/)
      end

      context 'when length is 1' do
        let(:length) { 1 }

        specify do
          expect(subject.random(length: length).length).to eq 8
        end

        specify do
          expect(subject.random(length: length)).to \
            match(/^[A-Z2-7]{#{length}}={#{8 - length}}$/)
        end
      end

      context 'when length is 29' do
        let(:length) { 29 }

        specify do
          expect(subject.random(length: length).length).to eq 32
        end

        specify do
          expect(subject.random(length: length)).to \
            match(/^[A-Z2-7]{#{length}}={#{32 - length}}$/)
        end
      end

      context 'when length is 40' do
        let(:length) { 40 }

        specify do
          expect(subject.random(length: length).length).to eq length
        end

        specify do
          expect(subject.random(length: length)).to \
            match(/^[A-Z2-7]{#{length}}$/)
        end
      end
    end

    context 'when padding is not default' do
      let(:padding) { false }

      specify do
        expect(subject.random(padding: padding)).to be_instance_of String
      end

      specify do
        expect(subject.random(padding: padding)).not_to be_empty
      end

      specify do
        expect(subject.random(padding: padding)).to match(/^[A-Z2-7]+$/)
      end

      specify do
        expect(subject.random(padding: padding).length).to eq 16
      end

      context 'when length is not default' do
        let(:length) { rand 1..1_000 }

        specify do
          expect(subject.random(length: length, padding: padding).length).to \
            eq length
        end

        specify do
          expect(subject.random(length: length, padding: padding)).to \
            match(/^[A-Z2-7]{#{length}}$/)
        end

        context 'when length is 1' do
          let(:length) { 1 }

          specify do
            expect(subject.random(length: length, padding: padding).length).to \
              eq length
          end

          specify do
            expect(subject.random(length: length, padding: padding)).to \
              match(/^[A-Z2-7]{#{length}}$/)
          end
        end

        context 'when length is 29' do
          let(:length) { 29 }

          specify do
            expect(subject.random(length: length, padding: padding).length).to \
              eq length
          end

          specify do
            expect(subject.random(length: length, padding: padding)).to \
              match(/^[A-Z2-7]{#{length}}$/)
          end
        end

        context 'when length is 40' do
          let(:length) { 40 }

          specify do
            expect(subject.random(length: length, padding: padding).length).to \
              eq length
          end

          specify do
            expect(subject.random(length: length, padding: padding)).to \
              match(/^[A-Z2-7]{#{length}}$/)
          end
        end
      end
    end
  end

  def hex_to_plain_string(hex)
    [hex].pack('H*')
  end
end
