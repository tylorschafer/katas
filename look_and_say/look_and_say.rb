class ArgumentError < StandardError; end

class LookAndSay
  def initialize(string)
    string.is_a?(Array) ? string = string.join() : string = string
    if string =~ /\d/
      @string = string
      @steps = 0
    else
      invalid_string
    end
  end

  def invalid_string
    raise ArgumentError, "Should not allow strings with non-digit characters"
  end

  def next
    @string = (@string.to_i + 10).to_s
    self
  end

  def to_s
    @string
  end
end
