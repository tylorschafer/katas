require 'matchers'

class TexasHoldEm

  def initialize(cards)
    split_cards = cards.split
    
    raise ArgumentError, "Must pass in 7 cards" unless split_cards.length == 7
    raise ArgumentError, "Must pass in distinct cards" unless split_cards.length == split_cards.uniq.length
    
    @cards = split_cards.map { |str| Card.new(str) }
    @hands = @cards.combination(5).map { |cards| Hand.new(cards) }
  end
  
  def best_hand
    hand_matcher = HandMatcher.new
    best_hand = @hands.sort_by { |hand| hand_matcher.evaluate(hand) }.last
    
    best_hand.match.to_s
  end
  
end

class Card
  
  attr_accessor :rank, :suit
  
  RANKS    = %w(2 3 4 5 6 7 8 9 10 J Q K A)
  MAX_RANK = RANKS.length - 1
  
  def initialize(string)
    match = string.match /(.+)([HSCD])/
    
    raise ArgumentError, "Invalid card: #{ string }" unless match && RANKS.include?(match[1])
    
    @rank = RANKS.index match[1]
    @suit = match[2]
  end
  
  def to_s
    RANKS[@rank] + @suit
  end
  
end

class Hand
  
  attr_accessor :cards, :match

  def initialize(cards)
    @cards = cards
  end
  
end

class PokerMatch

  def initialize(name, high_rank)
    @name = name
    @high = high_rank
  end
  
  def to_s
    "#{ @name } (#{ Card::RANKS[ @high ] } high)"
  end

end