class TexasHoldEm 
  def initialize(cards)
    @cards = []
    cards.split.each{|card| @cards << Card.new(card)}
    raise ArgumentError unless @cards.length == 7 
    raise ArgumentError unless cards.split.uniq.length == 7
    @all_hands = @cards.combination(5).map{|hand| Hand.new(hand)}   
  end  
  def best_hand
    @all_hands.sort[-1].to_s
  end  
end

class Card
  VALID_VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A)
  attr_reader :value, :suit
  def initialize(string)
    @suit = string[-1]
    @value = VALID_VALUES.index(string[0...-1])
    validate
  end
  def validate
    valid_suits = ["S","H","D","C"]
    unless valid_suits.include? @suit
      raise ArgumentError
    end
    unless @value
      raise ArgumentError
    end
  end
  def val
    @value
  end
end

class Hand 
  include Comparable
  attr_reader :rank
  def initialize(cards)
    @cards = cards
    calculate_rank
  end
  def <=>(other_hand)
    rank <=> other_hand.rank
  end
  def calculate_rank
    matcher = FlushMatcher.new(@cards)
    if matcher.matches?
      @rank = matcher.rank
      @matcher = matcher
    else
    matcher = FourOfAKindMatcher.new(@cards) #TODO spacing brah
    if matcher.matches?
      @rank = matcher.rank
      @matcher = matcher
    else
      matcher = TwoPairMatcher.new(@cards)
      if matcher.matches?
        @rank = matcher.rank
        @matcher = matcher
      else
        matcher = TwoOfAKindMatcher.new(@cards)
        if matcher.matches?
          @rank = matcher.rank
          @matcher = matcher
        else
          matcher = ThreeOfAKindMatcher.new(@cards)
          if matcher.matches?
            @rank = matcher.rank
            @matcher = matcher
          else
            @rank = [0]
          end  
        end
      end
    end
    end
  end
  def to_s
    @matcher.to_s
  end
end

class Matcher
  def initialize(cards)
    @cards = cards
    @base_rank = 0
    @grouped_cards = @cards.group_by(&:value)
  end
end 
  
class TwoOfAKindMatcher < Matcher
  def initialize(cards)
    super(cards)
    @base_rank = 1
  end
  def matches? 
    matched_cards = @grouped_cards.select{|value, cards| cards.count == 2}
    matched_values = matched_cards.keys
    @pair_value = matched_values.sort.last
  end
  def rank
    [@base_rank,@pair_value]
  end
  def to_s
    "Two of a Kind (#{Card::VALID_VALUES[@pair_value]} high)"
  end
end

class ThreeOfAKindMatcher < Matcher
  def initialize(cards)
    super(cards)
    @base_rank = 2
  end
  def matches? 
    matched_cards = @grouped_cards.select{|value, cards| cards.count > 2}
    matched_values = matched_cards.keys
    @pair_value = matched_values.sort.last
  end
  def rank
    [@base_rank,@pair_value]
  end
  def to_s
    "Three of a Kind (#{Card::VALID_VALUES[@pair_value]} high)"
  end
end

class FourOfAKindMatcher < Matcher
  def initialize(cards)
    super(cards)
    @base_rank = 4
  end
  def matches? 
    matched_cards = @grouped_cards.select{|value, cards| cards.count > 3}
    matched_values = matched_cards.keys
    @pair_value = matched_values.sort.last
  end
  def rank
    [@base_rank,@pair_value]
  end
  def to_s
    "Four of a Kind (#{Card::VALID_VALUES[@pair_value]} high)"
  end
end

class TwoPairMatcher < Matcher
  def initialize(cards)
    super(cards)
    @base_rank = 3
  end
  def matches? 
    matched_cards = @grouped_cards.select{|value, cards| cards.count == 2}
    matched_values = matched_cards.keys
    if matched_values.count > 1  
      @pair_value = matched_values.sort.last
    end
  end
  def rank
    [@base_rank,@pair_value]
  end
  def to_s
    "Two Pair (#{Card::VALID_VALUES[@pair_value]} high)"
  end
end

class FlushMatcher
  def initialize(cards)
    @cards = cards
    @base_rank = 7
  end
  def matches? 
    @grouped_cards = @cards.group_by(&:suit)
    matched_cards = @grouped_cards.select{|value, cards| cards.count == 5}
    #@high_card = matched_cards.sort_by{|k, v| v[@value]}.first.val 
    #@pair_value = matched_values.sort.last
    if matched_cards.size > 0
      @high_card = matched_cards.sort_by{|k, v| v.val}.first.val 
    end
  end
  def rank
    [@base_rank,@high_card]
  end
  def to_s
    "Flush (#{Card::VALID_VALUES[@high_card]} high)"
  end
end
=begin
class HighCarder < Matcher
  def initialize(cards)

  end
  def matches?
    matched_cards = @grouped_cards.select{|value, cards| cards.count == 2}
    matched_values = matched_cards.keys
    @pair_value = matched_values.sort.last
 end
end
=end

