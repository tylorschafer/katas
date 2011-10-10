class Jogger
  
  attr_accessor :smart, :long_legs, :good_rhythm, :fast, :name
  
  def initialize(name,options)
    @smart = options[:smart]
    @long_legs = options[:long_legs]
    @fast = options[:fast]
    @good_rhythm = options[:good_rhythm]
    
    @name = name
  end
  
  def race
    #implement me
  end
  
  
end