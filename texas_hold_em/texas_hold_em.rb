class TexasHoldEm
  
  def initialize(cards)
    @da_cards = cards
    hearts = @da_cards.split(/H/)
    #diamonds = @da_cards.scan(/[\dD][^\dH|C|S]*/)#.group_by(|a,b| puts a)
    clubs = @da_cards.scan(/[^\d H|D|S]*/)
    spades = @da_cards.split(/[S]/)
    #puts diamonds
    puts clubs
  end
  
  def best_hand
    # Implement me!
  end
  
end

b = TexasHoldEm.new("2D 4D 6D 7C 8C 9D 10D")