class LookAndSay
  
  def initialize(string)
    raise ArgumentError, "Can only accept a sequence of digits" unless string.to_s =~ /^[0-9]+$/
    @split = string.to_s.scan( /((.)\2*)/ ).map { |match| match.first }
  end

  def next
    LookAndSay.new @split.map { |sequence| [ sequence.length, sequence[0,1] ] }
  end

  def to_s
    @split.join
  end
  
end
