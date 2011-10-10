class HandMatcher
  
  SETS = [ "Royal Flush", "Straight Flush", "Four of a Kind", "Full House", "Flush", "Straight", "Three of a Kind", "Two Pair", "Two of a Kind", "High Card" ]
  
  def evaluate(hand)
    SETS.each_with_index do |set_name, set_order|
      method_name = "is_#{ set_name.downcase.tr(' ', '_') }?"
      
      if high_rank = send(method_name, hand)
        hand.match = PokerMatch.new(set_name, high_rank)
        return [ SETS.length - set_order, high_rank ]
      end
    end
  end
  
  ########################
  #                      #
  # Set Matching Methods #
  #                      #
  ########################
  
  def is_royal_flush?(hand)
    high_rank = SequenceFilter.new(hand.cards).high_rank && SuitFilter.new(hand.cards).high_rank
    high_rank == 12 ? high_rank : nil
  end
  
  def is_straight_flush?(hand)
    SequenceFilter.new(hand.cards).high_rank && SuitFilter.new(hand.cards).high_rank
  end
  
  def is_four_of_a_kind?(hand)
    RankFilter.new(hand.cards, 4).high_rank
  end
  
  def is_full_house?(hand)
    three = RankFilter.new(hand.cards, 3)
    two   = RankFilter.new(three.remainder, 2)
    
    three.high_rank if two.high_rank
  end
  
  def is_flush?(hand)
    SuitFilter.new(hand.cards).high_rank
  end
  
  def is_straight?(hand)
    SequenceFilter.new(hand.cards).high_rank
  end
  
  def is_three_of_a_kind?(hand)
    RankFilter.new(hand.cards, 3).high_rank
  end
  
  def is_two_pair?(hand)
    first  = RankFilter.new(hand.cards, 2)
    second = RankFilter.new(first.remainder, 2)
    
    first.high_rank if second.high_rank
  end

  def is_two_of_a_kind?(hand)
    RankFilter.new(hand.cards, 2).high_rank
  end
  
  def is_high_card?(hand)
    RankFilter.new(hand.cards, 1).high_rank
  end
  
end

class RankFilter

  attr_reader :remainder
  
  def initialize(cards, needed)
    @cards = cards
    @needed = needed
    @remainder = []
    
    high_rank
  end
  
  def high_rank
    Card::MAX_RANK.downto(0).each do |rank|
      selected = @cards.select { |c| c.rank == rank }
      
      if selected.count >= @needed
        @remainder = @cards - selected
        return rank
      end
    end
    
    return nil
  end
  
end

class SuitFilter

  def initialize(cards)
    @cards = cards
  end

  def high_rank
    suits = @cards.map { |card| card.suit }.uniq
    
    if suits.length == 1
      @cards.sort_by { |card| card.rank }.last.rank
    end
  end
  
end

class SequenceFilter

  def initialize(cards)
    @cards = cards
  end
  
  def high_rank
    ranks = @cards.map { |card| card.rank }.uniq.sort
    
    return ranks.last if ranks.length == @cards.length && (ranks.last - ranks.first) == 4
  end
  
end
