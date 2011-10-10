class TexasHoldEm
  
  def initialize(cards)
    @da_cards = cards
    hearts = @da_cards.scan(/[\dH]+[^\dD|C|S]+/)
    diamonds = @da_cards.scan(/[\dD]+[^\dH|C|S]+/)
    clubs = @da_cards.scan(/[\dC]+[^\dH|D|S]+/)
    spades = @da_cards.scan(/[\dS]+[^\dH|C|D]+/)
    #puts diamonds
    puts clubs
    #puts spades
  end
  
  def best_hand
    # Implement me!
  end
  
end

b = TexasHoldEm.new("2D 4D 6D 7C 8C 9D 10D")