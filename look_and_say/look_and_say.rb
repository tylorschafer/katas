class LookAndSay
  
  def initialize(string)
    @the_string = string
    #check = string.scan(/[^0-9]/)
    #if check.size != 0 
    #  raise ArgumentError, "Should not allow strings with non-digit characters" 
    #end  
  end

  def next
    out = ""
    @the_string.scan(/((\d)\2*)/).group_by{|a,b| out += a.size.to_s + b.to_s  }
   # puts out
    return LookAndSay.new(out)
  end

  def to_s
    @the_string
  end
  
end

#b = LookAndSay.new("12").next.to_s
#puts b.next
