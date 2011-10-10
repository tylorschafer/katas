class Frames
	# Frame Class
	class Frame
		def initialize(throws,index, n = nil)
    	if(!throws.kind_of?(String))
      	raise ArgumentError, "Frame parameter should be string"
    	end
    	@throws = throws 
			@next = n
      @index = index
      if(throws.size > 2)
        @two_roll = true
        @first = self.get_num(@throws[0])
        @second = self.get_num(@throws[1])
        if(throws.size == 3)
          @third = self.get_num(@throws[2])
        end
      else
        @two_roll = false
        @first = self.get_num(@throws[0])
      end
		end
		attr_reader :next, :val, :first, :second, :third
		attr_writer :next	
				
    def get_num(roll)
      if(roll == 'X')
        10
      elsif(roll == '/')
        10 - self.first
      elsif(roll == '-')
        0
      else
        roll.to_i
      end
    
    end    

    def two_roll?
      @two_roll
    end

   	def val
      if(@index < 10)
        if(@throws[0] == 'X')
          p = self.next
          if(p.two_roll?)
            score = p.first + p.second + 10
          else
            score = p.first
            p = p.next 
            score = score + p.first + 10
            @val = score.to_s
          end
          @val = score.to_s 
        elsif(@throws[1] == '/')
          p = self.next
          score = p.first + 10
          @val = score.to_s
        elsif self.two_roll?
          score = self.first + self.second
          @val = score.to_s
        end
      else
        if(@throws[0] == 'X' or @throws[1] == '/')
          score = self.first + self.second + self.third
          @val = score.to_s
        else
          score = self.first + self.second
          @val = score.to_s
        end 
        @val 
      end
      @val
		end

		def next
			@next
		end    
  end
	#end frame class

	def initialize(first)
		@head = Frame.new(first,1)
		@tail = @head
	end

	def add(frame)
		@tail.next = Frame.new(frame,self.size+1)
		@tail = @tail.next
	end

	def head
		@head
	end

	def tail
		@tail
	end

	def size
		count = 0
		p = @head
		while p 
				count = count + 1
				p = p.next
		end
		count
	end

	def at_front(frame)
		n = Frame.new(frame)
		n.next = @head
		@head = n
	end

	def at_end(frame)
	  @tail.next = Frame.new(frame)
	end

	def each
		p = @head
		while p
			yield p
			p = p.next
		end
	end
  
  def score
    score = 0
    self.each { |x| score = score + x.val.to_i }
    score  
  end
end

class Bowling
  
  class GameTooShort  < StandardError; end
  class GameTooLong   < StandardError; end
  class SpareTooEarly < StandardError; end
  class StrikeTooLate < StandardError; end
  class TooManyPins   < StandardError; end
  
  def initialize(throws)
    #print throws
    @throw = throws
    throws.each_char do |x|
      puts x
    end
      
  end
  
  def score
    @score
  end
  
end
