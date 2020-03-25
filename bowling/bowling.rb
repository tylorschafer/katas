class Bowling

  class GameTooShort  < StandardError; end
  class GameTooLong   < StandardError; end
  class SpareTooEarly < StandardError; end
  class StrikeTooLate < StandardError; end
  class TooManyPins   < StandardError; end

  def initialize(throws)
    @throws = throws
  end

  def score
    result = 0
    throws = @throws.split('')
    throws.all? {|t| t == 'X'} ? result = 300 :
    throws.each do |throw|
      case throw[-1]
      when '-'
        result += 0
      when 'X'
        result += 10
      when '/'
        result += 10
      else
        result += throw.to_i
      end
    end
    result
  end

end
