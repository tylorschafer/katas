class LookAndSay
  
  def initialize(string)
    raise ArgumentError, "Can only accept a sequence of digits" unless string.to_s =~ /^[0-9]+$/
    @split = string.to_s.scan( /((.)\2*)/ ).map { |chars, char| [ chars.length, char ] }
  end

  def next
    LookAndSay.new @split
  end

  def to_s
    @split.map { |length, char| char * length }.join
  end
  
end
