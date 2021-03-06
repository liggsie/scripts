#!/usr/bin/ruby

require 'securerandom'

class PwGen
  class LengthError < ArgumentError; end
  class NotNumericError < ArgumentError; end
  attr_reader :length 

  Lowercase = ('a'..'z').to_a
  Uppercase = ('A'..'Z').to_a
  Numbers = (0..9).to_a
  Symbols = %q{`~@#%^&*()-_=+[]{}\|;:'",.<>/?}.split //
  DefaultLen = 32
  ValidLengthRange = (6..256)

  def initialize(length=DefaultLen)
    unless _is_number? length
      raise(NotNumericError, 'Argument must be a valid number!')
    end
    length = length.to_i
    unless ValidLengthRange.include? length
      raise(LengthError, 'Length must be within the range %s' % ValidLengthRange.to_s)
    end
    @length = length
  end

  def _is_number?(val)
    true if Integer(val) rescue false
  end

  def _next
    all_chars[SecureRandom.random_number all_chars.length]
  end

  def all_chars
    Lowercase + Uppercase + Numbers + Symbols
  end

  def pw
    result = Array.new
    @length.times do 
      result << _next
    end
    return result.join
  end
end


def main
  if ARGV.length > 0
    p = PwGen.new ARGV[0]
  else
    p = PwGen.new
  end
  puts p.pw
end


if __FILE__ == $0
  main
end
