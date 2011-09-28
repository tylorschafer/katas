class Bowling
  
  class GameTooShort  < StandardError; end
  class GameTooLong   < StandardError; end
  class SpareTooEarly < StandardError; end
  class StrikeTooLate < StandardError; end
  class TooManyPins   < StandardError; end
  
  def initialize(throws)
    @frames = BowlingParser.parse throws
    
    check_validity
  end
  
  def score
    @frames.inject(0) { |sum, frame| sum + frame.score }
  end
  
  def check_validity
    raise GameTooShort, "#{ @frames.length } frames is too few"  if @frames.length < 10
    raise GameTooLong,  "#{ @frames.length } frames is too many" if @frames.length > 10
    
    @frames.each { |frame| frame.check_validity }
  end

end

class BowlingParser

  def self.parse(throws)
    factory      = FrameFactory.new
    split_throws = throws.split(/(X|..)/, 10) - ['']
    
    split_throws.reverse.map { |frame| factory.make frame }.reverse
  end
  
end

class FrameFactory

  def make(throws)
    klass = if @next_frame.nil?
      LastFrame
    elsif throws == 'X'
      StrikeFrame
    elsif throws[1,1] == '/'
      SpareFrame
    else
      Frame
    end
    
    @next_frame = klass.new(throws, @next_frame)
  end
  
end

class Frame

  def initialize(throws, next_frame)
    @throws = throws.split('')
    @next_frame = next_frame
  end

  # Scoring
  
  def score
    first_throw + second_throw + bonus
  end
  
  def first_throw
    throw_to_i @throws[0]
  end
  
  def second_throw
    throw_to_i @throws[1], @throws[0]
  end

  def bonus
    0
  end
  
  # Validity
  
  def check_validity
    raise Bowling::SpareTooEarly if @throws[0] == '/'
    raise Bowling::StrikeTooLate if @throws[1] == 'X'
    raise Bowling::TooManyPins   if @throws[0].to_i + @throws[1].to_i >= 10
  end

  # Helpers
  
  def throw_to_i(current, last = '-')
    case current
      when 'X' then 10
      when '/' then 10 - throw_to_i(last)
      else current.to_i
    end
  end
  
end

class SpareFrame < Frame
  
  def bonus
    @next_frame.first_throw
  end
  
end

class StrikeFrame < Frame
  
  def bonus
    @next_frame.second_throw
  end
  
  def second_throw
    @next_frame.first_throw
  end
  
end

class LastFrame < Frame
  
  def bonus
    throw_to_i @throws[2], @throws[1]
  end
  
  def check_validity
    expected_throws = (@throws[0..1] & %w(/ X)).empty? ? 2 : 3

    raise Bowling::GameTooShort, "Expected #{ expected_throws } throws in final frame, found #{ @throws.length }"  if @throws.length < expected_throws
    raise Bowling::GameTooLong,  "Expected #{ expected_throws } throws in final frame, found #{ @throws.length }"  if @throws.length > expected_throws
  end
  
end
