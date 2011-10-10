class Bowling
  
  class GameTooShort  < StandardError; end
  class GameTooLong   < StandardError; end
  class SpareTooEarly < StandardError; end
  class StrikeTooLate < StandardError; end
  class TooManyPins   < StandardError; end
  
  def initialize(throws)
    @the_throws = throws
    @the_score = 0
    bowl = @the_throws.split(//,0)
    i = 0
    frame_count = 0
    t1 = ""
    t2 = ""
    puts bowl[1] == "/"
    loop do
      if bowl[i] == "9"#TODO make into range
        if t1 == ""
          t1 = bowl[i]
          @the_score += bowl[i].to_i
        else
          t2 = bowl[i]
          @the_score += bowl[i].to_i
          t1 = ""
          frame_count += 1
          #if t1.to_i +  TODO check for score >=10
        end 
        i += 1
        puts i
      end
      if bowl[i] == "/"
        if t1 == ""
           raise SpareTooEarly
        else
           @the_score += 10 - t1.to_i + bowl[i+1].to_i
           frame_count += 1
           t1 = ""
        end
        i += 1
        puts i
      end
      if bowl[i] == "X"
        if t1 == ""
          @the_score += 10 + bowl[i+1].to_i + bowl[i+2].to_i
          frame_count += 1
        else
          raise StrikeTooLate
        end  
        i += 1
        puts i
      end
      if bowl[i] == "-"
        if t1 == ""
          t1 = 0
        else
          t2 = 0
          t1 = ""
          frame_count += 1
        end  
        i += 1
        puts i
      end
      
      break if i == 21
    end
    puts 
  end
  
  def score
    @the_score
  end
  
end

puts Bowling.new("9/" * 10 + '9')
