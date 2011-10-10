class Bowling
  
  class GameTooShort  < StandardError; end
  class GameTooLong   < StandardError; end
  class SpareTooEarly < StandardError; end
  class StrikeTooLate < StandardError; end
  class TooManyPins   < StandardError; end
  
  def initialize(throws)
    @frames = BowlingParser.new(throws).frames
    
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

##################
#                #
# Bowling Parser #
#                #
##################

class BowlingParser

  attr_reader :frames
  
  def initialize(throws)
    split_throws = throws.split(/(X|..)/, 10) - ['']
    
    @frames = split_throws.reverse.map { |frame| make_frame frame }.reverse
  end

  def make_frame(throws)
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

#########
#       #
# Frame #
#       #
#########

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

###############
#             #
# Spare Frame #
#             #
###############

class SpareFrame < Frame
  
  def bonus
    @next_frame.first_throw
  end
  
end

################
#              #
# Strike Frame #
#              #
################

class StrikeFrame < Frame
  
  def bonus
    @next_frame.second_throw
  end
  
  def second_throw
    @next_frame.first_throw
  end
  
end

##############
#            #
# Last Frame #
#            #
##############

class LastFrame < Frame
  
  def bonus
    throw_to_i @throws[2], @throws[1]
  end
  
  def check_validity
    frame = @throws.join

    raise Bowling::GameTooShort,  "Expected 3 throws in final frame, found #{ @throws.length }"  if frame =~ /^([X\/].|.[X\/])$/ || @throws.length < 2
    raise Bowling::GameTooLong,   "Expected 2 throws in final frame, found #{ @throws.length }"  if frame =~ /[-1-9]{2}./ || frame =~ /..../
    raise Bowling::SpareTooEarly, "Cannot throw a spare at the start of a frame in #{ frame }"   if frame =~ /[X\/]\// || frame =~ /^\//
    raise Bowling::StrikeTooLate, "Cannot throw a strike inside a frame in #{ frame }"           if frame =~ /[-1-9]X/
    raise Bowling::TooManyPins,   "Too many pins without a spare or strike in #{ frame }"        if frame =~ /X?[-1-9]{2}/ && (@throws[0].to_i + @throws[1].to_i + @throws[2].to_i) >= 10
  end
  
end
